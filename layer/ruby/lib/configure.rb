module Configure
  def self.aws()
    require 'aws-sdk-core'

    options = { region: ENV['AWS_REGION'] || 'us-west-2'}
    options.merge!(endpoint: 'http://localstack:4566') if ENV['environment'] == 'development'
    Aws.config.update(options)
  end

  def self.dynamoid(options: {})
    require "dynamoid"

    Dynamoid.configure do |config|
      config.namespace = nil
      config.timestamps = true
      config.endpoint = 'http://localstack:4566' if ENV['environment'] == 'development'
    end
  end
end