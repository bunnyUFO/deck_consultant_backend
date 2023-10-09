# Deck Consultant Backend

Back end for game titled deck consultant.
In the game you play as a deck consultant that lends magical cards to clients who are adventures going on quests.<br>
If adventurer succeeds on quest, you get lent cards back plus a percentage of quest reward.<br>
If adventurer does not complete quest, you get lent cards back but no reward.<br>
If the clients die on adventure, you lose lent cards.<br>

The backend uses dynamoid ruby gem to query dynamo db database for user data.

## response from lambda get user request
```json
{
  "user_id": "some_cognito_id",
  "username": "username",
  "gold": 100,
  "reputation": 10,
  "cards": {
    "slash": 5,
    "block": 5
  }
}
```

`user_id` is cognito sub attribute used as primary key (ther is no sorting key)<br>
`username` username is cognito username attribute<br>
`gold` is the users gold amount used to buy new booster-packs and quire cards<br>
`reputation` is the users gold amount used to buy new booster-packs and quire cards<br>
`cards` card counts for each card name (stored as serialized ruby object because it is using dynamoid custom class)

## File Structure
```text
|── lambdas                                     <-- folder for lambdas (each lambda has subfolder)
│   ├── lambda_name                             <-- example folder for lambda 
│   │   ├── lambda_name.rb                      <-- Lambda function main code with handler
│   │   ├── Gemfile.rb                          <-- Gemfile used to build lambda (must include gems from layers used)
├── layers                                      <-- folder for lamdba layers
│   ├── layer_name                              <-- folder for lamdba ayer code
│   │   ├── ruby                                <-- folder for ruby files like gems and source code
│   │   │   ├── lib                             <-- folder for library source code (gets included in lambdas)
│   │   ├── Gemfile                             <-- Gemfile for lamdba code 
├── spec                                        <-- Spec folder for all lambdas
│   ├── spec_helper                             <-- Lightweight spec helper just for lambdas
├── .rspec                                      <-- rpsec config to include layer files fot tests
├── .ruby-gemset                                <-- Gemset for gemini lamdbas (only used for specs)
├── .ruby-version                               <-- Ruby version for gemini lamdbas (only used for specs, currently 2.6.3 because deploy issues)
├── build.sh                                    <-- Script to create lamdba docker images
├── invoke.sh                                   <-- Script to invoke lambda (first parameter is lambda resource name second one is event path)
├── dev_template.yaml                           <-- SAM Cloudformation template to build lambdas on localstack
├── template.yaml                               <-- SAM Cloudformation template used for real deploys
├── Gemfile                                     <-- Gemfile for specs only
```

## Unit Testing
To run all unit tests use `rake`
This will run rspec to execute all specs from spec folder

## Acceptance Testing
To run locally you should have sam-cli installed and localstack running from a [docker container](https://mmarcosab.medium.com/running-localstack-with-docker-7c6597acddd1)<br>

 First we need to build lambdas<br>
 `./build.sh`

Now we can invoke lambdas with this script<br>
`./invoke.sh <lamdba name> <event>`

Running without parameters will invoke CreateUser lamdba with default values<br>
`./invoke.sh`

Here are some CreateUser invocations with custom parameters<br>
```bash
./invoke.sh CreateUser '{"user_id": "user-1", "username": "name", "gold": 500, "reputation": 50}'

./invoke.sh CreateUser '{"user_id": "user-1", "username": "name", "gold": 10, "reputation": 10,\
                        "cards": { "slash": 3, "magic missle": 4, "block": 4, "holy light": 2 } }'                        
```


Examples for GetUser:<br>
```bash
./invoke.sh GetUser
./invoke.sh GetUser '{ "user_id": "2" }'
```

Examples for UpdateUser:<br>
```bash
./invoke.sh UpdateUser
./invoke.sh UpdateUser '{ "user_id": "1", "gold": 10, "reputation": 5, "cards": {"healing word": 1} }'
./invoke.sh UpdateUser '{ "user_id": "1", "cards": {"healing word": 1} }'
./invoke.sh UpdateUser '{ "user_id": "1", "gold": 10}'
./invoke.sh UpdateUser '{ "user_id": "1", "reputation": 5 }'
```
