require 'configure'

def create_user(event: nil, context: nil)
  puts event
  puts context
  Configure.dynamoid(options: { test: 'test'})
  { message: 'testing' }
end
