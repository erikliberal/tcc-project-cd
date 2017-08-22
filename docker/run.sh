#!/bin/bash
cd "$(dirname ${0})"
if [ "x$(docker volume ls | grep -o 'nexus-data')x" == 'xx' ] ; then
  docker volume create --name nexus-data
fi
docker run -d --rm --name nexus -v nexus-data:/nexus-data sonatype/nexus3
if [ "x$(docker volume ls | grep -o 'jenkins-data')x" == 'xx' ] ; then
    docker volume create --name jenkins-data
fi
docker run --name=jenkins --rm --link nexus:nexus -v jenkins-data:/var/jenkins_home -u root -d jenkins
docker cp jenkins/settings.xml jenkins:/var/jenkins_home/settings.xml
