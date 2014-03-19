lua_ngx_status_stat
===================

Nginx Lua module to collect reply status counters.
See `nginx.conf` for example.

`collect_statuses.lua` module collect status counters for requests across location with `log_by_lua_file 'collect_statuses.lua';` directive.
`show_statuses_stat.lua` show collected counters in html, or JSON(request "Content-Type" should be "application/json").
