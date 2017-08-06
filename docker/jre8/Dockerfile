FROM openjdk:8-jre-alpine
MAINTAINER Erik Liberal <erik.liberal@gmail.com>

RUN addgroup -g 1000 jboss && \
mkdir -p /opt/jboss && \
adduser -D -u 1000 -G jboss -h /opt/jboss -s /sbin/nologin jboss && \
chown jboss:jboss /opt/jboss && \
chmod 755 /opt/jboss
RUN apk update && \
apk add curl

WORKDIR /opt/jboss

USER jboss
