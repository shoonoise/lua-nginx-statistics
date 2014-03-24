# Testing for nginx Lua module to collect statuses statistic
#
# VERSION 1.0

FROM ubuntu:12.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python python-requests vim
ADD tests.py /home/

CMD python /home/tests.py -v
