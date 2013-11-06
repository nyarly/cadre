module Cadre
  class Notifier
    class << self
      def registry
        @registry ||= {}
      end

      def register(name)
        Notifier.registry[name] = self
      end

      def get
        registry.each_pair do |name, notifier|
          return notifier if notifier.available?
        end

        return DumbNotifier
      end

      def availables
        @availables ||= Hash.new{|h,k| h[k] = system("which", k, :out => "/dev/null")}
      end
    end

    def available?(program)
      self.class.availables[program]
    end

    def initialize
      yield self if block_given?
    end

    attr_accessor :summary, :message, :sound, :expire_time, :app_name, :transient

    def go
    end
  end

  class DumbNotifier < Notifier
    def go
      puts summary
      puts message
    end
  end
end

require 'cadre/libnotify/notifier'
require 'cadre/growl/notifier'
