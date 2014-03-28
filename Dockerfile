# Nginx Lua module to collect statuses statistic
#
# VERSION 1.0

FROM nikicat/ubuntu:12.04

# Nginx
RUN add-apt-repository ppa:nginx/stable
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y liblua5.1-json nginx-extras

# Statistic module
ADD nginx.conf /etc/nginx/nginx.conf
ADD collect_stats.lua /usr/share/nginx/
ADD show_stat.lua /usr/share/nginx/
ADD common_stat.lua /usr/share/nginx/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

CMD nginx
