local json = require "json"
local stat_dict = ngx.shared.stat_dict
local collect_module = require "collect_stats"

ser_data = stat_dict:get("stat")

if not ser_data then
  ngx.say("No data yet.")
  ngx.exit(ngx.OK)
end

data = json.decode(ser_data)

-- Build _total field
local _total = collect_module.init_location_group("status")
for _, v in pairs(data["status"]) do
  for s, c in pairs(v) do
    _total[s] = _total[s] + c
  end
end
data["status"]["_total"] = _total

-- Build reply

if ngx.req.get_headers()["Content-Type"] == "application/json" then
  -- Reply JSON if content type application/json
  ngx.header.content_type = "application/json"
  ngx.say(json.encode(data))

else
  -- Reply HTML in other ways
  local html_reply = {}

  table.insert(html_reply, "<html><head><title>Nginx statistic</title></head><body>")
  table.insert(html_reply, "<h1>Statuses:</h1>")

  for group, value in pairs(data["status"]) do
    table.insert(html_reply, "<h2>" .. group .. "</h2")
    for s, c in pairs(value) do
      table.insert(html_reply, "<b>" .. s .. "</b> has occurred "
                               .. tostring(c) .. " times" .. "</p>")
    end
  end

  table.insert(html_reply, "</body></html>")

  ngx.say(html_reply)
end
