From centos:7

MAINTAINER "Erik Liberal" <erik.liberal@gmail.com>
ENV container docker

ADD gocd.repo /etc/yum.repos.d/gocd.repo

RUN \
# groupadd -g 1000 go && \
# useradd -D -u 1000 -G go go && \
yum -q -y update && \
# yum -q -y --nogpgcheck install sudo && \
# yum -q -y --nogpgcheck install httpd && \
yum -q -y --nogpgcheck install git && \
yum -q -y --nogpgcheck install openssh-clients && \
yum -q -y --nogpgcheck install unzip && \
yum -q -y --nogpgcheck install telnet && \
yum -q -y --nogpgcheck install java-1.8.0-openjdk && \
yum -q -y --nogpgcheck install go-server && \
yum clean all
# systemctl enable httpd.service && \
# systemctl start httpd.service

EXPOSE 8153 8154

ENV LANG=en_US.utf8

USER go

RUN ssh-keygen -q -f "${HOME}/.ssh/id_rsa" -N ""

# CMD ["/usr/sbin/init"]
CMD ["/etc/init.d/go-server start"]
