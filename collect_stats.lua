local json = require("json")
local common = require("common_stat")

local stat_dict = ngx.shared.stat_dict
local status = tostring(ngx.status)
local upstream_time = tonumber(ngx.var.request_time) * 1000
local location_group = ngx.var.stat_counter

-- Set default group, if it's not defined by nginx variable
if not location_group or location_group == "" then
  location_group = 'other_locations'
end

json_stat = stat_dict:get("stat")
if json_stat then
  ngx.log(ngx.INFO, "There is serialized data ", json_stat)
  stat_data = json.decode(json_stat)
else
  ngx.log(ngx.INFO, " There is no data in shared dict ")
  stat_data = {["status"] = {[location_group] = common.init_location_group("status")},
               ["timings"] = {[location_group] = common.init_location_group("timings")}}
end

-- Get serialized data from shared dict or create new if it doesn exist
local function get_data(stat_type)
  if stat_data[stat_type][location_group] then
    ngx.log(ngx.INFO, " There is data for ", stat_type, " type.")
    if stat_data[stat_type][location_group] then
      return stat_data[stat_type][location_group]
    else
      return init_location_group(stat_type)
    end
  else
    ngx.log(ngx.INFO, " There is no data for ", stat_type, " type. So init it.")
    return common.init_location_group(stat_type)
  end
end

-- Define in which category status should be
local function get_status_code_class(status_code)
  ngx.log(ngx.INFO, "Get code class for ", status_code)
  if     status_code:sub(1,1) == '1' then return "1xx"
  elseif status_code:sub(1,1) == '2' then return "2xx"
  elseif status_code:sub(1,1) == '3' then return "3xx"
  elseif status_code:sub(1,1) == '4' then return "4xx"
  elseif status_code:sub(1,1) == '5' then return "5xx"
  else                                    return "xxx"
  end
end

-- Define in which category response time should be
local function get_histogram_state(t)
  ngx.log(ngx.INFO, "Get histogram state for ", t)
  if not t                     then return "undef"
  elseif t >= 0  and t < 100  then return "0-100"
  elseif t >= 100 and t < 500  then return "100-500"
  elseif t >= 500 and t < 1000 then return "500-1000"
  elseif t >= 1000             then return "1000-inf"
  end
end

local function build_stat(location_data, stat_type, value)
  ngx.log(ngx.INFO, " Build stat for ", stat_type, "type. And ", value, " value.")
  ngx.log(ngx.INFO, "Current location data ", json.encode(location_data))
  if stat_type == "status" then
    ngx.log(ngx.INFO, " Get class for status ")
    stat_class = get_status_code_class(value)
  elseif stat_type == "timings" then
    ngx.log(ngx.INFO, " Get class for timings ")
    stat_class = get_histogram_state(value)
  end
  ngx.log(ngx.INFO, " Class ", stat_class)

  location_data[stat_class] = location_data[stat_class] + 1
  ngx.log(ngx.INFO, " New location data ", json.encode(location_data))
  return location_data
end

local statuses = build_stat(get_data("status"), "status", status)
ngx.log(ngx.INFO, " statuses ", json.encode(statuses))

local timings = build_stat(get_data("timings"), "timings", upstream_time)
ngx.log(ngx.INFO, " timings ", json.encode(timings))

stat_data["status"][location_group] = statuses
stat_data["timings"][location_group] = timings

ngx.log(ngx.INFO, " stat data ", json.encode(stat_data))

stat_dict:set("stat", json.encode(stat_data))
