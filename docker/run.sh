#!/bin/bash
if [ "x$(ps --no-headers -o comm 1)x"=="xsystemdx"  ] && [ "$(systemctl is-active docker.service)" == 'inactive' ] ; then
    echo 'Inicializando serviço do docker'
    sudo systemctl start docker.service;
fi
cd "$(dirname ${0})"
if [ "x$(docker volume ls | grep -o 'gitlab-data')x" == 'xx' ] ; then
  echo 'Criando volume para persistir os dados do gitlab entre inicializações'
  docker volume create --name gitlab-data
fi

echo "gitlab [ $(docker run -d --rm --name gitlab -e GITLAB_ROOT_PASSWORD='erikliberal@infoxx2017!' -e GITLAB_ROOT_EMAIL='erik.liberal@gmail.com' -v gitlab-data:/var/opt/gitlab gitlab/gitlab-ce:9.4.5-ce.0) ] on ip < $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' gitlab) >"

if [ "x$(docker volume ls | grep -o 'nexus-data')x" == 'xx' ] ; then
  echo 'Criando volume para persistir os dados do nexus entre inicializações'
  docker volume create --name nexus-data
fi
echo "nexus [ $(docker run -d --rm --name nexus -v nexus-data:/nexus-data sonatype/nexus3) ] on ip < $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nexus) >"
if [ "x$(docker volume ls | grep -o 'jenkins-data')x" == 'xx' ] ; then
    echo 'Criando volume para persistir os dados do jenkins entre inicializações'
    docker volume create --name jenkins-data
fi
echo "jenkins [ $( docker run --name=jenkins --rm --link gitlab:gitlab --link nexus:nexus -v jenkins-data:/var/jenkins_home -u root -d jenkins ) ] on ip < $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jenkins) >"
docker cp .m2 jenkins:/root/.m2
