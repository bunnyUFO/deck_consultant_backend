#!/bin/bash
# Development script to build lambda
WORKSPACE=${WORKSPACE:=`pwd`}
TEMPLATE=${1:-"dev_template.yaml"}

sam build \
  --docker-network host \
  --use-container \
  --template $WORKSPACE/$TEMPLATE