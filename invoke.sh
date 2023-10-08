#!/bin/bash
# Development script to build lambda
WORKSPACE=${WORKSPACE:=`pwd`}
TEMPLATE=${TEMPLATE:-"dev_template.yaml"}
LAMBDANAME=${1:-"CreateUser"}
PAYLOAD=${2:-'{ "data": "test" }'}

  echo $PAYLOAD | sam local invoke \
    --docker-network host \
    --region us-west-2 \
    --event - \
    $LAMBDANAME
