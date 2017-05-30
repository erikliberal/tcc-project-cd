#!/bin/bash
cd "$(dirname ${0})"
docker build -q --force-rm=true --rm=true -t erikliberal/jdk8 jdk8
docker build -q --force-rm=true --rm=true -t erikliberal/jre8 jre8
docker build --force-rm=true --rm=true -t erikliberal/gocd-server gocd-server
docker build --force-rm=true --rm=true -t erikliberal/gocd-server-instance gocd-server-instance
