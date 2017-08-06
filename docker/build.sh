#!/bin/bash
cd "$(dirname ${0})"
docker build --force-rm=true --rm=true -t erikliberal/jdk8:latest jdk8
docker build --force-rm=true --rm=true -t erikliberal/jre8:latest jre8
docker build --force-rm=true --rm=true -t erikliberal/wildfly:10.0.0.Final -t erikliberal/wildfly:latest wildfly
