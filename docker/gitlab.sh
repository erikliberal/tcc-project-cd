#!/bin/bash
gitlab_root_password='erikliberal@infoxx2017!'
gitlab_root_email='erik.liberal@gmail.com'
gitlab_data_volume='gitlab-data'
gitlab_container_name='gitlab'
network_gitlab_ip=172.19.0.2
network_name=redeInfraInterna
if [ "x$(ps --no-headers -o comm 1)x"=="xsystemdx"  ] && [ "$(systemctl is-active docker.service)" == 'inactive' ] ; then
    echo 'Inicializando serviço do docker'
    sudo systemctl start docker.service;
fi
cd "$(dirname ${0})"

if [ "x$(docker volume ls | grep -o ""$gitlab_data_volume"")x" == 'xx' ] ; then
  echo 'Criando volume para persistir os dados do gitlab entre inicializações'
  docker volume create --name $gitlab_data_volume
fi
gitlab_sid=$(docker run -d --rm \
    --ip "$network_gitlab_ip" \
    --network "$network_name" \
    --network-alias "$gitlab_container_name" \
    --name $gitlab_container_name \
    -e GITLAB_ROOT_PASSWORD="$gitlab_root_password" \
    -e GITLAB_ROOT_EMAIL="$gitlab_root_email" \
    -v $gitlab_data_volume:/var/opt/gitlab gitlab/gitlab-ce:9.4.5-ce.0)
gitlab_instance_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$gitlab_container_name")
echo "gitlab [ $gitlab_sid ] on ip < $gitlab_instance_ip >"
