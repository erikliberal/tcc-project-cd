#!/bin/bash
JBOSS_FOLDER=/opt/jboss
STANDALONE_FOLDER=$JBOSS_FOLDER/wildfly/standalone
BUILD_FOLDER=$(pwd)/target
mkdir -p "$BUILD_FOLDER/"{logs,deployments}
docker run -d --rm --name wildfly -p 8080:8080 -p 9990:9990 \
  -v "$BUILD_FOLDER/deployments":${STANDALONE_FOLDER}/deployments \
  -v "$BUILD_FOLDER/logs":${STANDALONE_FOLDER}/log \
  erikliberal/wildfly:latest
