require 'configure'
require 'user'

def update_user(event: nil, context: nil)
  Configure.aws
  Configure.dynamoid

  user = DeckConsultant::User.find(event['user_id'])
  user.gold = event['gold'] if event['gold']
  user.reputation = event['reputation'] if event['gold']
  user.set_cards(event['cards'])
  user.set_quests(event['quests'])

  if user.changed? || event['cards'] ||event['quests']
    user.save!
  else
    return { warning: "user not changed since it already has same values" }
  end

  user.as_hash

rescue Dynamoid::Errors::RecordNotFound
  { message: "User with user_id #{event['user_id']} not found" }

rescue Dynamoid::Errors::DocumentNotValid => e
  { error: e.message }
end