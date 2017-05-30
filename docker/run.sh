#!/bin/bash
#docker run --rm -d -p 8153:8153 -p 8154:8154 local/go-cd-server
mkdir -p "$(pwd)/logs"
docker run -d --rm -p 8153:8153 -p 8154:8154 -v "$(pwd)/logs":/var/log/go-server --name "gocd-server" erikliberal/gocd-server-instance
