# Deck Consultant Backend

Back end for game titles deck consultant built using AWS SAM ruby lambdas using dynamoid. 


## File Overview
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
├── events                                      <-- Lambda event payloads folder, used for specs and to call lambdas locally
│   ├── example_event.json                      <-- Example event file 
├── spec                                        <-- Spec folder for all lambdas
│   ├── spec_helper                             <-- Lightweight spec helper just for lambdas
├── .rspec                                      <-- rpsec config to include layer files fot tests
├── .ruby-gemset                                <-- Gemset for gemini lamdbas (only used for specs)
├── .ruby-version                               <-- Ruby version for gemini lamdbas (only used for specs, currently 2.6.3 because deploy issues)
├── build.sh                                    <-- Script to create lamdba docker images
├── deploy.sh                                   <-- Script to deploy lamdbas on AWS
├── invoke_filter_supply_events_lambda.sh       <-- Script to invoke lambda (first parameter is lambda resource name second one is event path)
├── local_template.yaml                         <-- SAM Cloudformation template to build lambdas on localstack
├── template.yaml                               <-- SAM Cloudformation template used for real deploys
├── Gemfile                                     <-- Gemfile for specs only
```
