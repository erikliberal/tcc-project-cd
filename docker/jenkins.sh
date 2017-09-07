#!/bin/bash
jenkins_data_volume='jenkins-data'
jenkins_container_name='jenkins'
network_jenkins_ip=172.19.0.4
network_name=redeInfraInterna
if [ "x$(ps --no-headers -o comm 1)x"=="xsystemdx"  ] && [ "$(systemctl is-active docker.service)" == 'inactive' ] ; then
    echo 'Inicializando serviço do docker'
    sudo systemctl start docker.service;
fi
cd "$(dirname ${0})"

if [ "x$(docker volume ls | grep -o ""$jenkins_data_volume"")x" == 'xx' ] ; then
  echo 'Criando volume para persistir os dados do jenkins entre inicializações'
  docker volume create --name $jenkins_data_volume
fi
jenkins_sid=$(docker run -d --rm \
    --ip "$network_jenkins_ip" \
    --network "$network_name" \
    --network-alias "$jenkins_container_name" \
    --name $jenkins_container_name \
    -v $jenkins_data_volume:/var/jenkins_home jenkins/jenkins:2.60.2)
jenkins_instance_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$jenkins_container_name")
echo "jenkins [ $jenkins_sid ] on ip < $jenkins_instance_ip >"
docker exec $jenkins_container_name mkdir -p /var/jenkins_home/.m2
docker cp settings.xml $jenkins_container_name:/var/jenkins_home/.m2/settings.xml
