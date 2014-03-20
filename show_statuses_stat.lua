local json = require "cjson"
local stat_dict = ngx.shared.stat_dict

ser_data = stat_dict:get("stat")

if not ser_data then
  ngx.say("No data yet.")
  ngx.exit(ngx.OK)
end

if ngx.req.get_headers()["Content-Type"] == "application/json" then
  -- Reply JSON if content type application/json
  ngx.header.content_type = "application/json"
  ngx.say(ser_data)

else
  -- Reply HTML in other ways
  local html_reply = {}
  local data = json.decode(ser_data)

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
