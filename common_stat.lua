local _M = {}

-- Predefine categories
function _M.init_location_group(stat_type)
  ngx.log(ngx.INFO, " init location group for ", stat_type)
  if stat_type == "status" then
    return {["1xx"] = 0,
            ["2xx"] = 0,
            ["3xx"] = 0,
            ["4xx"] = 0,
            ["5xx"] = 0,
            ["xxx"] = 0}
  elseif stat_type == "timings" then
    return {["0-100"]    = 0,
            ["100-500"]  = 0,
            ["500-1000"] = 0,
            ["1000-inf"] = 0,
            ["undef"]    = 0}
  end
end

return _M

