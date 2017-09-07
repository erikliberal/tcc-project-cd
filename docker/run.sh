#!/bin/bash
cd "$(dirname ${0})"
sh rede.sh
sh gitlab.sh
sh nexus.sh
sh jenkins.sh
