require 'configure'
require 'user'

def get_user(event: nil, context: nil)
  Configure.aws
  Configure.dynamoid

  user = DeckConsultant::User.find(event['user_id'])
  user.user_data.merge(cards: user.card_data)

rescue Dynamoid::Errors::RecordNotFound
  { message: "User with user_id #{event['user_id']} not found" }
end