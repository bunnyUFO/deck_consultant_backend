#!/bin/bash
# Development script to build lambda
WORKSPACE=${WORKSPACE:=`pwd`}
TEMPLATE=${1:-"template.yaml"}

./build.sh $TEMPLATE
sam deploy $TEMPLATE \
  --capabilities CAPABILITY_NAMED_IAM \
  --stack-name "DeckConsultant" \
  --no-fail-on-empty-changeset \
