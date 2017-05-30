From centos:7

MAINTAINER "Erik Liberal" <erik.liberal@gmail.com>
ENV container docker

RUN \
yum -q -y update && \
yum -q -y --nogpgcheck install java-1.8.0-openjdk && \
yum -q clean all

ENV LANG=en_US.utf8

CMD ["/usr/sbin/init"]
