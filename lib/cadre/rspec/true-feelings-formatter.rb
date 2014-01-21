require 'rspec/core/formatters/progress_formatter'

module Cadre::RSpec
  class TrueFeelingsFormatter < RSpec::Core::Formatters::ProgressFormatter
    def example_passed(example)
      if @failed_examples.empty?
        super
      else
        output.print failure_color("u")
      end
    end
  end
end

Uuu = Cadre::RSpec::TrueFeelingsFormatter
