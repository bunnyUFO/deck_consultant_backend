require 'rspec'
require 'rake'
require 'rspec'
require 'logger'
require 'nokogiri'
require 'aws-sdk-core'
require 'aws-sdk-dynamodb'
require 'dynamoid'

# Reduce noise in test output
Dynamoid.logger.level = Logger::FATAL
Dynamoid.configure do |config|
  config.namespace = 'deck_consultant'
end

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.configure do |config|

  config.before(:each) do
    DeckConsultant::User.destroy_all
    DeckConsultant::Quest.destroy_all
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  def override_stdout
    $stderr = File.open(File::NULL, "w")
    $stdout = File.open(File::NULL, "w")
  end

  def reset_stdout
    $stderr = STDERR
    $stdout = STDOUT
  end
end