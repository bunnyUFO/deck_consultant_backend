require 'configure'
require 'user'

def update_user(event: nil, context: nil)
  Configure.aws
  Configure.dynamoid

  user = DeckConsultant::User.find(event['user_id'])
  user.set_data(gold: event['gold'], reputation: event['reputation'])
  user.set_cards(event['cards'])

  if user.changed? || event['cards']
    user.save!
  else
    return { warning: "user not changed since it already has same values" }
  end

  user.user_data.merge(cards: user.card_data)

rescue Dynamoid::Errors::RecordNotFound
  { message: "User with user_id #{event['user_id']} not found" }

rescue Dynamoid::Errors::DocumentNotValid => e
  { error: e.message }
end