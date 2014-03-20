local json = require "cjson"

local stat_dict = ngx.shared.log_dict
local data = {}
local statuses = stat_dict:get_keys(20)

for _, s in pairs(statuses) do 
  data[s] = stat_dict:get(s)
end

if ngx.req.get_headers()["Content-Type"] == "application/json" then
  -- Reply JSON if content type application/json
  ngx.header.content_type = "application/json"
  ngx.say(json.encode(data)) 
else
  -- Reply HTML in other ways
  local html_reply = {}
  table.insert(html_reply, "<html><head><title>Nginx status statistic</title></head><body>")
      
  for s, c in pairs(data) do
    table.insert(html_reply, "<p> status <b>" .. s .. "</b> has occurred " .. tostring(c) .. " times" .. "</p>" )
  end
  table.insert(html_reply, "</body></html>")
  ngx.say(html_reply)
end