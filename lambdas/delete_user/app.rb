require 'configure'
require 'user'
require 'card_count'

def delete_user(event: nil, context: nil)
  Configure.aws
  Configure.dynamoid

  user = DeckConsultant::User.find(event['user_id'])
  username = user.username
  user.destroy

  { message: "Deleted user with username #{username}" }

rescue Dynamoid::Errors::RecordNotFound
  { message: "User with user_id #{event['user_id']} not found" }
end
