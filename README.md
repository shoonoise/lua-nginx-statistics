Nginx statistic module
===================

## Overview

Nginx Lua module to collect reply status counters.
See `nginx.conf` for example.

`collect_statuses.lua` module collect status counters for requests across location with `log_by_lua_file 'collect_statuses.lua';` directive.

`show_statuses_stat.lua` show collected counters in html, or JSON(request "Content-Type" should be "application/json").

## Try it with docker

### Build it from Dockerfiles

* Install [Docker](https://www.docker.io/)
* clone this repo
* cd into repo's root
* Build image `docker build -t ngx_stat_img .`
* Run container `docker run -p 80:80 --name=ngx_stat -d ngx_stat_img`

Last command return container id, so you can use it to check logs by `docker logs _container_id_`.

To check that it is works go to `http://localhost` and other location like `http://localhost/304` or `http://localhost/500`,
and on `http://localhost/status_stat` to get statistic page or `curl -H "Content-Type: application/json" http://localhost/status_stat` to get JSON.

You also can run container with test suite:

* cd in tests directory
* Build image `docker build -t ngx_test_img .`
* Run container `docker run -i -t --link=ngx_stat:web ngx_test_img`

Last command should return result of tests.

### Get image from docker index

You can just pull image from index.docker.io by `docker pull  shoonoise/lua-ngx-statuses-collector`.

## Tips and Tricks

1. You may want to use lua [cjson](http://www.kyne.com.au/~mark/software/lua-cjson-manual.html) module instead of `liblua5.1-json` for performance purpose.
Just install cjson from [ppa](https://launchpad.net/ubuntu/+source/lua-cjson) and replace `local json = require("json")` to `local json = require("cjson")`
in lua scripts.

2. Set `$stat_counter` nginx variable in config to group statuses.

For example set `$stat_counter $uri` to collect statuses for each uri separately.
