require 'logger'

module Configure
  def self.dynamoid(options: {})
    Logger.new(STDOUT).info(options)
  end
end