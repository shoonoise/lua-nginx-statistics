# Nginx Lua module to collect statuses statistic
#
# VERSION 1.0


FROM ubuntu:12.04

# Prepare
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common python-software-properties vim git curl tmux

# Nginx
RUN add-apt-repository ppa:nginx/stable
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make liblua5.1-json nginx-extras

# Statistic module
ADD nginx.conf /etc/nginx/nginx.conf
ADD collect_statuses.lua /usr/share/nginx/
ADD show_statuses_stat.lua /usr/share/nginx/

EXPOSE 80

CMD nginx && tail -f /usr/share/nginx/error.log