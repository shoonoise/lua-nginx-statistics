# Nginx Lua module to collect statuses statistic
#
# VERSION 1.0


FROM ubuntu:12.04

# Openresty(nginx with lua)
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make wget liblua5.1-json
RUN wget http://openresty.org/download/ngx_openresty-1.4.3.9.tar.gz
RUN tar xvfz ngx_openresty-1.4.3.9.tar.gz
RUN cd ngx_openresty-1.4.3.9 ; ./configure --with-luajit  --with-http_addition_module --with-http_dav_module --with-http_gzip_static_module --with-http_realip_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-ipv6 --with-pcre-jit;  make ; make install

# Statistic module
ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD collect_statuses.lua /usr/local/openresty/nginx/
ADD show_statuses_stat.lua /usr/local/openresty/nginx/
RUN echo "daemon off;" >> /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 80

CMD /usr/local/openresty/nginx/sbin/nginx -p /usr/local/openresty/nginx/ -c conf/nginx.conf