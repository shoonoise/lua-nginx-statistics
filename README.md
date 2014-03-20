Nginx statistic module
===================

Overview
-------------------

Nginx Lua module to collect reply status counters.
See `nginx.conf` for example.

`collect_statuses.lua` module collect status counters for requests across location with `log_by_lua_file 'collect_statuses.lua';` directive.

`show_statuses_stat.lua` show collected counters in html, or JSON(request "Content-Type" should be "application/json").

Try it with docker
--------------------

### Using Dockerfiles

* Install [Docker](https://www.docker.io/)

* clone this repo

* cd into repo's root

* Build image `docker build -t ngx_stat_img .`

* Run container `docker run -p 80:80 -name ngx_stat -d ngx_stat_img`


Last command return container id, so you can use it to check logs by `docker logs _container_id_`.


You also can run container with test suite:

* cd in tests directory

* Build image `docker build -t ngx_test_img .`

* Run container `docker --link=ngx_stat:web ngx_test_img`

Last command should return result of tests.