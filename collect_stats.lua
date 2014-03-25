module ("collect_stats", package.seeall)
local json = require("json")

local stat_dict = ngx.shared.stat_dict
local status = tostring(ngx.status)
local upstream_time = tonumber(ngx.var.upstream_response_time)
local location_group = ngx.var.stat_counter

-- Set default group, if it's not defined by nginx variable
if not location_group or location_group == "" then
  location_group = 'other_locations'
end

-- Predefine categories
function init_location_group(type)
  if type == "status" then
    return {["1xx"] = 0,
            ["2xx"] = 0,
            ["3xx"] = 0,
            ["4xx"] = 0,
            ["5xx"] = 0,
            ["xxx"] = 0}
  elseif type == "timings" then
    return {["0-100"]    = 0,
            ["100-500"]  = 0,
            ["500-1000"] = 0,
            ["1000-inf"] = 0}
  end
end

-- Get serialized data from shared dict or create new if it doesn exist
function get_data(type)
  local ser_stat = stat_dict:get("stat")
  if ser_stat then
    return json.decode(ser_stat)
  else
    return {[type] = {[location_group] = init_location_group(type)}}
  end
end

-- Define in which category status should be
function get_status_code_class(status_code)
  if     status_code:sub(1,1) == '1' then return "1xx"
  elseif status_code:sub(1,1) == '2' then return "2xx"
  elseif status_code:sub(1,1) == '3' then return "3xx"
  elseif status_code:sub(1,1) == '4' then return "4xx"
  elseif status_code:sub(1,1) == '5' then return "5xx"
  else                                    return "xxx"
  end
end

-- Define in which category response time should be
function get_histogram_state(t)
  if     t > 0   and t < 100  then return "0-100"
  elseif t > 100 and t < 500  then return "100-500"
  elseif t > 500 and t < 1000 then return "500-1000"
  else                             return "1000-inf"
  end
end

-- Update or create location group
function build_stat(data, type, value)
  for i, _ in pairs(data) do
    if i == type then

      if i == "status" then
        stat_class = get_status_code_class(value)
      elseif i == "timings" then
        stat_class = get_histogram_state(value)
      end

      if not data[type][location_group] then
        data[type][location_group] = init_location_group(type)
      end

      if data[type][location_group][stat_class] then
        local old_count = data[type][location_group][stat_class]
        data[type][location_group][stat_class] = old_count + 1
      end

      return data
    end
  end
end

statuses = build_stat(get_data("status"), "status", status)
ngx.log(ngx.INFO, " statuses ", json.encode(statuses))

timings = build_stat(get_data("timings"), "timings", upstream_time)
ngx.log(ngx.INFO, " timings ", json.encode(timings))

stat = {}
table.insert(stat, statuses)
table.insert(stat, timings)
ngx.log(ngx.INFO, " stat ", json.encode(stat))

stat_dict:set("stat", json.encode(stat))
