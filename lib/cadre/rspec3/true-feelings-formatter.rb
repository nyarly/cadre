module Cadre::RSpec3
  class TrueFeelingsFormatter < RSpec::Core::Formatters::BaseFormatter
    include RSpec::Core::Formatters::ConsoleCodes

    RSpec::Core::Formatters.register self, :example_passed, :example_failed

    def initialize(output)
      super
      @any_fails_yet = false
    end

    def example_failed(notification)
      @any_fails_yet = true
    end

    def example_passed(example)
      unless @any_fails_yet
        super
      else
        output.print wrap("u", :failure)
      end
    end
  end
end

Uuu = Cadre::RSpec3::TrueFeelingsFormatter
