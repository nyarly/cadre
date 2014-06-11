require 'cadre/rspec'
require 'cadre/simplecov'
require 'cadre/command-line'
require 'cadre/growl/notifier'

module RSpec::Core::Formatters
  def self.register(*args)
  end

  module ConsoleCodes
  end
end

require 'cadre/rspec3'
