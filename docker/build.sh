#!/bin/bash
cd "$(dirname ${0})"
docker build -q --force-rm=true --rm=true -t erikliberal/jdk8 jdk8
docker build -q --force-rm=true --rm=true -t erikliberal/gocd-server gocd-server
