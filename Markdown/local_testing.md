## Acceptance Testing
To run acceptance testing we will run lamdba using [sam-cli commands](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-command-reference.html).<br>
The scripts `./build` and `./invoke` are configured to use `template.yaml`, which has the minimum neede to invoke the lamdbas. 

## Prerequisites
 - [install sam-cli](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)
 - [install docker](https://docs.docker.com/engine/install/)
 - [run localstack docker container](https://mmarcosab.medium.com/running-localstack-with-docker-7c6597acddd1)<br>

If lambdas are not able to access aws resources you may need to edit docker network to match localstack on scripts.

## How to Invoke Lambdas Locally
First we need to build lambdas<br>
`./build.sh`

Now we can invoke lambdas with this script<br>
`./invoke.sh <lamdba_name> <event>`

**lamdba_name**: resource name for lambda to invoke from dev_template.yaml<br>
**event**: json string to pass in to lambda handler function<br>

Running without parameters will invoke CreateUser lamdba with default values<br>
**default lamdba_name**: CreateUser<br>
**default event**: `'{ "user_id": "1", "username": "username", "gold": 100, "reputation": 0, "cards": {"slash": 5, "block": 5} }'`

Look at [lambda reponse paylaod](/Markdown/lambda_response_format.md) for more info on events and response payload format

### CreateUser
Creates new user with data supplied, returns hash representation of it.

supported event keys:
 - user_id (required)
 - username (required)
 - gold (required)
 - reputation (required)
 - card (optional)

Example for creating user with all supported parameters<br>
```bash
# Create user with default values
./invoke.sh CreateUser 
# Create user with custom values
./invoke.sh CreateUser \
'{
  "user_id": "2", "username": "name", "gold": 10, "reputation": 10,
  "cards": {"slash": 3, "magic missile": 4, "block": 4, "holy light": 2}
}'                        
```

### GetUser
Gets user by id and returna json hash representation of it

supported event keys:
- user_id (required)

Example for GetUser:<br>
```bash
# Get user with default user_id
./invoke.sh GetUser
# Get user with specified user_id
./invoke.sh GetUser '{ "user_id": "2" }'
```

### UpdateUser
Updates user info with data supplied.<br>

supported event keys:
- user_id (required)
- username (required)
- gold (optional)
- reputation (optional)
- cards (optional)

Examples for UpdateUser:<br>
```bash
# set gold and reputation
./invoke.sh UpdateUser '{ "user_id": "1", "gold": 10, "reputation": 5'
# set cards
./invoke.sh UpdateUser '{ "user_id": "1", "cards": {"slash": 6, "block": 3, "healing word": 3 } }'
# create pending quest
./invoke.sh UpdateUser \
'{"user_id": "1",
  "quests": [{ 
    "scenario_id": 2, "complete": false, "random_seed": 2, "duration": 60,
    "deck": { "slash": 5, "block": 5 }
    }]
}'
# update pending quest to complete
./invoke.sh UpdateUser \
'{"user_id": "1",
  "quests": [{ 
    "id": "104decdb-6bf8-437b-ba8b-cd8f0aab58a2", "complete": true
  }]
}'
```

### DeleteUser
Deletes user and quests.<br>

supported event keys:
- user_id (required)

Examples for UpdateUser:<br>
```bash
# delete user with default user_id
./invoke.sh DeleteUser
# delte user with specifed user_id
./invoke.sh UpdateUser '{ "user_id": "2"}'
```
