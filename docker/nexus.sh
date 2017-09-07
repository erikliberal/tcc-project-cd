#!/bin/bash
nexus_data_volume='nexus-data'
nexus_container_name='nexus'
network_nexus_ip=172.19.0.3
network_name=redeInfraInterna
if [ "x$(ps --no-headers -o comm 1)x"=="xsystemdx"  ] && [ "$(systemctl is-active docker.service)" == 'inactive' ] ; then
    echo 'Inicializando serviço do docker'
    sudo systemctl start docker.service;
fi
cd "$(dirname ${0})"

if [ "x$(docker volume ls | grep -o ""$nexus_data_volume"")x" == 'xx' ] ; then
  echo 'Criando volume para persistir os dados do nexus entre inicializações'
  docker volume create --name $nexus_data_volume
fi

nexus_sid=$(docker run -d --rm \
    --ip "$network_nexus_ip" \
    --network "$network_name" \
    --network-alias "$nexus_container_name" \
    --name $nexus_container_name \
    -v $nexus_data_volume:/nexus-data sonatype/nexus3:3.5.0)
nexus_instance_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$nexus_container_name")
echo "nexus [ $nexus_sid ] on ip < $nexus_instance_ip >"
