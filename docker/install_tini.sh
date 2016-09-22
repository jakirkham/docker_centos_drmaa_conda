#!/bin/bash

yum update -y -q
yum install -y -q curl grep sed
TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'`
yum install -y -q "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.rpm"
yum clean all -y -q
