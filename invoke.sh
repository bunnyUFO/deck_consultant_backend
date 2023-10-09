#!/bin/bash
# Development script to build lambda
WORKSPACE=${WORKSPACE:=`dirname $0`}
TEMPLATE=${TEMPLATE:-"dev_template.yaml"}
LAMBDANAME=${1:-"CreateUser"}
PAYLOAD=${2:-'{ "user_id": "1", "username": "username", "gold": 100, "reputation": 0, "cards": {"slash": 5, "block": 5} }'}

  echo $PAYLOAD | sam local invoke\
    --docker-network localstack_default\
    --region us-west-2 \
    --event - \
    $LAMBDANAME
