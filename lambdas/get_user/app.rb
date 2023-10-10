require 'configure'
require 'user'

def get_user(event: nil, context: nil)
  Configure.aws
  Configure.dynamoid

  DeckConsultant::User.find(event['user_id']).as_hash

rescue Dynamoid::Errors::RecordNotFound
  { message: "User with user_id #{event['user_id']} not found" }
end