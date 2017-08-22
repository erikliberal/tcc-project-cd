FROM jenkins:latest

USER root

COPY settings.xml /tmp

RUN mkdir -vp /var/jenkins_home/.m2 && \
  mv -v /tmp/settings.xml /var/jenkins_home/.m2/settings.xml && \
  chown -R 1000:1000 /var/jenkins_home

USER jenkins

VOLUME /var/jenkins_home
