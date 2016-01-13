require 'cadre/rspec'
load 'cadre/simplecov.rb'
load 'cadre/simplecov/vim-formatter.rb'
require 'cadre/command-line'
require 'cadre/growl/notifier'

module RSpec::Core::Formatters
  def self.register(*args)
  end

  module ConsoleCodes
  end
end

require 'cadre/rspec3'
