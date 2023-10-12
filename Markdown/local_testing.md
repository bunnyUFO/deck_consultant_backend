## Acceptance Testing
To run acceptance testing we will run lamdba using [sam-cli commands](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-command-reference.html).<br>
The scripts `./build` and `./invoke` are configured to use `template.yaml`, which has the minimum neede to invoke the lamdbas. 

## Prerequisites
 - [install sam-cli](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)
 - [install docker](https://docs.docker.com/engine/install/)
 - [run localstack docker container](https://mmarcosab.medium.com/running-localstack-with-docker-7c6597acddd1)<br>

If lambdas are not able to access aws resources you may need to edit docker network to match lcoalstack on scripts.

## How to Invoke Lambdas Locally
First we need to build lambdas<br>
`./build.sh`

Now we can invoke lambdas with this script<br>
`./invoke.sh <lamdba_name> <event>`

**lamdba_name**: resource name for lambda to invoke from dev_template.yaml<br>
**event**: json string to pass in to lambda handler function<br>

**List of keys events support:<br>**
`id`: string dynamodb primary key to identify user, is a cognito identifier (required)<br>
`username`: string username staroed in dynamodb (required)<br>
`gold`: integer value of gold currency (optional)<br>
`reputation`: integear value of reputation used as experience (optional)<br>
`card`: map where each key is the card name and value is interer of card count in inventory (optional)<br>

Running without parameters will invoke CreateUser lamdba with default values<br>
**default lamdba_name**: CreateUser<br>
**default event**:<br>
`'{ "user_id": "1", "username": "username", "gold": 100, "reputation": 0, "cards": {"slash": 5, "block": 5} }'`

### CreateUser
Creates new user with data supplied, returns json string representation of it.

supported event keys:
 - id (required)
 - username (required)
 - gold (required)
 - reputation (required)
 - card (optional)

Example for creating user with all supported parameters<br>
```bash
./invoke.sh CreateUser '{"user_id": "user-1", "username": "name", "gold": 10, "reputation": 10,\
                        "cards": { "slash": 3, "magic missle": 4, "block": 4, "holy light": 2 } }'                        
```

### GetUser
Gets user by id and return hash representation of it

supported event keys:
- id (required)

Example for GetUser:<br>
```bash
./invoke.sh GetUser '{ "user_id": "2" }'
```

### UpdateUser
Updates user info.<br>
For maps like cards will only update keys/value pair provided and not overwrite other keys.
Setting a card count to zero will delete the whole key value pair instead.

supported event keys:
- id (required)
- username (required)
- gold (optional)
- reputation (optional)
- card (optional)

Examples for UpdateUser:<br>
```bash
# update gold and card count for "healing word"
./invoke.sh UpdateUser '{ "user_id": "1", "gold": 10, "reputation": 5, "cards": {"healing word": 1} }'
# remove healing word from table
./invoke.sh UpdateUser '{ "user_id": "1", "cards": {"healing word": 0} }'
# create pending quest card counts must add up to 10
./invoke.sh UpdateUser '{"user_id": "1","quests": [{ "scenario_id": 2, "complete": false, "random_seed": 2, "duration": 60, "deck": { "slash": 5, "block": 5 }}]}'
# update quest to complete
./invoke.sh UpdateUser '{"user_id": "1","quests": [{ "id": "104decdb-6bf8-437b-ba8b-cd8f0aab58a2", "complete": true}]}'
```
