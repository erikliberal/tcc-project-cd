#!/bin/bash
if [ "x$(ps --no-headers -o comm 1)x"=="xsystemdx"  ] && [ "$(systemctl is-active docker.service)" == 'inactive' ] ; then
    echo 'Inicializando serviço do docker'
    sudo systemctl start docker.service;
fi
cd "$(dirname ${0})"

user_created_network_name=redeInfraInterna
if [ 0 -eq $(docker network ls | grep -c $user_created_network_name) ] ; then
    echo "Criando rede $user_created_network_name";
    docker network create --subnet 172.19.0.0/16 --gateway 172.19.0.1 --driver bridge $user_created_network_name
fi

if [ 0 -eq $(docker volume ls | grep -c 'gitlab-data') ] ; then
  echo 'Criando volume para persistir os dados do gitlab entre inicializações'
  docker volume create --name gitlab-data
fi
echo "gitlab [ $(docker run -d --rm --name gitlab --ip 172.19.0.2 --network $user_created_network_name --network-alias gitlab -e GITLAB_ROOT_PASSWORD='erikliberal@infoxx2017!' -e GITLAB_ROOT_EMAIL='erik.liberal@gmail.com' -v gitlab-data:/var/opt/gitlab gitlab/gitlab-ce:9.4.5-ce.0) ] on ip < $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' gitlab) >"

if [ "x$(docker volume ls | grep -o 'nexus-data')x" == 'xx' ] ; then
  echo 'Criando volume para persistir os dados do nexus entre inicializações'
  docker volume create --name nexus-data
fi
echo "nexus [ $(docker run -d --rm --name nexus --ip 172.19.0.3 --network $user_created_network_name --network-alias nexus -v nexus-data:/nexus-data sonatype/nexus3:3.5.0) ] on ip < $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nexus) >"

if [ "x$(docker volume ls | grep -o 'jenkins-data')x" == 'xx' ] ; then
    echo 'Criando volume para persistir os dados do jenkins entre inicializações'
    docker volume create --name jenkins-data
fi
echo "jenkins [ $( docker run -d --rm --name=jenkins --ip 172.19.0.4 --network $user_created_network_name --network-alias jenkins -v jenkins-data:/var/jenkins_home jenkins/jenkins:2.60.2 ) ] on ip < $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jenkins) >"
docker exec jenkins mkdir -p /var/jenkins_home/.m2
docker cp settings.xml jenkins:/var/jenkins_home/.m2/settings.xml
