local json = require("json")
local common = require("common_stat")
local stat_dict = ngx.shared.stat_dict

ser_data = stat_dict:get("stat")

if ser_data then
  data = json.decode(ser_data)
else
  data = {["status"]  = {["_total"] = common.init_location_group("status")},
          ["timings"] = {["_total"] = common.init_location_group("timings")}}
end

-- Build _total field
local _total = common.init_location_group("status")
ngx.log(ngx.INFO, "Total ", json.encode(_total))

for _, v in pairs(data["status"]) do
  for s, c in pairs(v) do
    _total[s] = _total[s] + c
  end
end
data["status"]["_total"] = _total

-- Reply JSON if content type application/json
ngx.header.content_type = "application/json"
ngx.say(json.encode(data))
