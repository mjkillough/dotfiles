#!/usr/bin/bash

BRANCH=$1

git checkout "$1"
git fetch > /dev/null
git reset --hard origin/$BRANCH
