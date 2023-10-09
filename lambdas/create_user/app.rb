require 'configure'
require 'user'
require 'card_count'

def create_user(event: nil, context: nil)
  Configure.aws
  Configure.dynamoid

  user = DeckConsultant::User.new(
    user_id: event['user_id'],
    username: event['username'],
    gold: event['gold'],
    reputation: event['reputation'])

  user.set_cards(event['cards'])
  user.save!

  { message: "Created user with username #{user.username}" }

rescue Dynamoid::Errors::RecordNotUnique
  { message: "User with user_id #{event['user_id']} already exists" }
end