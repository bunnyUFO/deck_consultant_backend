#!/bin/bash
# Development script to build lambda
WORKSPACE=${WORKSPACE:=`pwd`}
TEMPLATE=${1:-"dev_template.yaml"}

DOCKER_CLIENT_TIMEOUT=500 \
COMPOSE_HTTP_TIMEOUT=500 \
sam build \
  --docker-network localstack_default\
  --use-container \
  --template $WORKSPACE/$TEMPLATE