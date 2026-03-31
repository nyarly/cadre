module Cadre
  class Config
    def initialize(valise, component)
      @valise = valise
      @component = component
    end
    attr_reader :valise, :component

    def config_hash
      valise.find("config.yaml").contents
    end

    def value_or_fail(value, common=true)
      if common
        config_hash.fetch(component, {}).fetch(value){config_hash.fetch(value)}
      else
        config_hash.fetch(component).fetch(value)
      end
    rescue KeyError
      raise "Field not configurated: #{value}" #yep: configurated
    end

    def output_path
      value_or_fail("output_path", false)
    end

    def verbose
      !!value_or_fail("verbose")
    end
    alias verbose? verbose

    def quiet
      !verbose
    end
    alias quiet? quiet

    def sound
      !!value_or_fail("sound")
    end
    alias sound? sound

    def backtrace_pattern
      Regexp.new(value_or_fail('backtrace_pattern'))
    end

    def backtrace_limit
      value_or_fail('backtrace_limit')
    end

    def include_pending
      !!value_or_fail('include_pending')
    end
    alias include_pending? include_pending
  end
end
