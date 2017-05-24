From erikliberal/jdk8:latest

MAINTAINER "Erik Liberal" <erik.liberal@gmail.com>
ENV container docker

ADD gocd.repo /etc/yum.repos.d/gocd.repo

RUN \
groupadd -g 1000 go && \
useradd -D -u 1000 -G go go && \
yum -q -y update && \
# yum -q -y --nogpgcheck install sudo && \
# yum -q -y --nogpgcheck install httpd && \
yum -q -y --nogpgcheck install openssh-clients && \
yum -q -y --nogpgcheck install git && \
yum -q -y --nogpgcheck install unzip && \
yum -q -y --nogpgcheck install telnet && \
yum -q -y --nogpgcheck install go-server && \
yum -q -y --nogpgcheck install go-agent && \
yum clean all
# systemctl enable httpd.service && \
# systemctl start httpd.service

EXPOSE 8153 8154

ENV LANG=en_US.utf8
#contains the binaries and database
VOLUME /var/lib/go-server
#contains the pipeline configuration files
VOLUME /etc/go
#contains the server logs
VOLUME /var/log/go-server
#contains the start script
#VOLUME /usr/share/go-server
#contains all the environment variables with default values. These variable values can be changed as per requirement.
VOLUME /etc/default/go-server

USER go

RUN ssh-keygen -q -f "${HOME}/.ssh/id_rsa" -N "" && cat "${HOME}/.ssh/id_rsa.pub"

USER root

ADD entrypoint.sh /usr/local/sbin/entrypoint

RUN chmod 0755 /usr/local/sbin/entrypoint

CMD ["/usr/local/sbin/entrypoint"]
