local stat_dict = ngx.shared.log_dict
local status = ngx.status
local curr_count = stat_dict:get(status)
      
if curr_count then
  local new_count, err = stat_dict:incr(status, 1)
  
  if new_count then 
    ngx.log(ngx.INFO, " Current counter for ", status, " is ", new_count)
  else
    ngx.log(ngx.ALERT, " Error while increase status counter ", err)
  end

else
      ngx.log(ngx.INFO, " Create new counter for ", status, " status ")
      ok, err = stat_dict:set(status, 1)
      if not ok then
        ngx.log(ngx.ALERT, " Error while create status counter ", err)
      end
end
