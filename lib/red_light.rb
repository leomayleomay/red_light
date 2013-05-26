require "red_light/version"
require 'red_light/railtie' if defined?(Rails)

module RedLight
  mattr_accessor :authentications
  @@authentications = []

  def self.setup
    yield self
  end
end
