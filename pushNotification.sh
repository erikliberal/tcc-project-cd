#!/bin/bash
curl "$JENKINS_URL/git/notifyCommit?url=$(git remote get-url origin)"
