local json = require("json")
local common = require("common_stat")
local stat_dict = ngx.shared.stat_dict

json_data = stat_dict:get("stat")

if json_data then
  data = json.decode(json_data)
else
  data = {["status"]  = {["_total"] = common.init_location_group("status")},
          ["timings"] = {["_total"] = common.init_location_group("timings")}}
end

-- Build _total field
local function build_total_field(stat_type)
  local _total = common.init_location_group(stat_type)
  ngx.log(ngx.INFO, "Total ", json.encode(_total))
  for _, v in pairs(data[stat_type]) do
    for s, c in pairs(v) do
      _total[s] = _total[s] + c
    end
  end
  return _total
end

data["status"]["_total"] = build_total_field("status")
data["timings"]["_total"] = build_total_field("timings")

ngx.header.content_type = "application/json"
ngx.say(json.encode(data))
