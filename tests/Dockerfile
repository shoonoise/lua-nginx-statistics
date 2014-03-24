# Testing for lua nginx statistic module
#
# VERSION 1.0

FROM nikicat/ubuntu:12.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-requests
ADD tests.py /home/

CMD python /home/tests.py -v
