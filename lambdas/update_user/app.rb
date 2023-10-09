require 'configure'
require 'user'

def update_user(event: nil, context: nil)
  Configure.aws
  Configure.dynamoid

  user = DeckConsultant::User.find(event['user_id'])
  user.gold = event['gold'] if event['gold']
  user.reputation = event['reputation'] if event['reputation']

  if user.changed?
    user.save!
  else
    return { warning: "user not changed since it already has same values" }
  end

  user.as_json.transform_keys(&:to_sym)

rescue Dynamoid::Errors::RecordNotFound
  { message: "User with user_id #{event['user_id']} not found" }

rescue Dynamoid::Errors::DocumentNotValid => e
  { error: e.message }
end