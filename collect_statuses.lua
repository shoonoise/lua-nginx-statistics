local json = require("cjson")
local stat_dict = ngx.shared.stat_dict
local status = tostring(ngx.status)
local location_group = ngx.var.stat_counter

function init_location_group()
  local location_group = {
                          ["1xx"] = 0,
                          ["2xx"] = 0,
                          ["3xx"] = 0,
                          ["4xx"] = 0,
                          ["5xx"] = 0,
                          ["xxx"] = 0
                         }
  return location_group
end

-- Set default group, if it's not defined by nginx variable
if not location_group or location_group == "" then
  location_group = 'other_locations'
end

-- Get serialized data from dict or create new
local ser_stat = stat_dict:get("stat")
if ser_stat then
  stat = json.decode(ser_stat)
else
  stat = {["status"] = {[location_group] = init_location_group()}}
end

function get_status_code_class(status_code)
  if     status_code:sub(1,1) == '1' then return "1xx"
  elseif status_code:sub(1,1) == '2' then return "2xx"
  elseif status_code:sub(1,1) == '3' then return "3xx"
  elseif status_code:sub(1,1) == '4' then return "4xx"
  elseif status_code:sub(1,1) == '5' then return "5xx"
  else                                    return "xxx"
  end
end

for i, _ in pairs(stat) do
  if i == "status" then
    local status_class = get_status_code_class(status)

    if not stat["status"][location_group] then
      stat["status"][location_group] = init_location_group()
    end

    if stat["status"][location_group][status_class] then
      local old_count = stat["status"][location_group][status_class]
      stat["status"][location_group][status_class] = old_count + 1
    end
  end
end

stat_dict:set("stat", json.encode(stat))
ngx.log(ngx.ALERT, " stat ", json.encode(stat))
