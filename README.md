Nginx statistic module
===================
[![Build Status](https://travis-ci.org/shoonoise/lua-nginx-statistics.svg?branch=master)](https://travis-ci.org/shoonoise/lua-nginx-statistics)
## Overview

Nginx Lua module to collect and show statistics.
See `nginx.conf` for example.

`collect_statuses.lua` module collect statistics for requests across location with `log_by_lua_file 'collect_stats.lua';` directive.

`show_stat.lua` response for JSON reply.

## Try it

For a start, you need nginx with [HttpLuaModule](http://wiki.nginx.org/HttpLuaModule), and lua json lib installed (`liblua5.1-json` for ubuntu).

* Clone this repository
* Copy \*.lua files from root to some path(`/usr/share/nginx/`, in example below)

Update your `nginx.conf`:

* Add `lua_shared_dict stat_dict 1M;` in http section
* Add `lua_package_path '/usr/share/nginx/?.lua;;';` in http section
* Add `log_by_lua_file '/usr/share/nginx/collect_stats.lua';` directive in location from which to you want collect statistic
* Add new location to get statistic and put `/usr/share/nginx/content_by_lua_file 'show_stat.lua'` directive inside
* Enjoy!

## Try it with docker

### Build it from Dockerfiles

* Install [Docker](https://www.docker.io/)
* clone this repo
* cd into repo's root
* Build image `docker build -t ngx_stat_img .`
* Run container `docker run -p 80:80 --name=ngx_stat -d ngx_stat_img`

Last command return container id, so you can use it to check logs by `docker logs _container_id_`.

To check that it is works go to `http://localhost` and other location like `http://localhost/304` or `http://localhost/500`,
and on `http://localhost/show_stat/` to get statistic page or `curl http://localhost/stat` to get JSON.

You also can run container with test suite:

* cd in tests directory
* Build image `docker build -t ngx_test_img .`
* Run container `docker run -i -t --link=ngx_stat:web ngx_test_img`

Last command should return result of tests.

### Get image from docker index

You can just pull image from index.docker.io by `docker pull shoonoise/lua-nginx-statistics`.

## Tips and Tricks

1. You may want to use lua [cjson](http://www.kyne.com.au/~mark/software/lua-cjson-manual.html) module instead of `liblua5.1-json` for performance purpose.
Just install cjson from [ppa](https://launchpad.net/ubuntu/+source/lua-cjson) and replace `local json = require("json")` to `local json = require("cjson")`
in lua scripts.

2. Set `$stat_counter` nginx variable in config to group statuses.

For example set `$stat_counter $uri` to collect statuses for each uri separately.
