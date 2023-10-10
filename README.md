# Deck Consultant Backend

Back end for game titled deck consultant.<br>
In the game you play as a deck consultant that lends magical cards to clients who are adventures going on quests.<br>

Backend uses [dynamoid](https://github.com/Dynamoid/dynamoid) ruby gem to model dynamodb tables.<br>
Game client uses Lambda functions to get and mutate player data.

## Testing
To run all unit tests use `rake`
This will run rspec to execute all specs from spec folder

## Documentation
- [Dunamo Tables](/Markdown/dynamo_tables.md)
- [Locally invoking Lambdas](/Markdown/local_testing.md)

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