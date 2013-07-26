require 'cadre/valise'

module Cadre
  module Libnotify
    class Notifier
      def initialize
        yield self if block_given?
      end

      attr_accessor :summary, :message, :sound, :expire_time, :app_name, :transient

      def go
        cmd = "notify-send #{options} \"#@summary\" \"#@message\""
        %x[#{cmd}]
        %x[paplay #{Valise.find(["sounds", sound]).full_path}] if String === sound
      end

      def options
        options = []
        unless expire_time.nil?
          options << "-t #@expire_time"
        end

        if transient
          options << "-h \"byte:transient:1\""
        end

        unless app_name.nil?
          options << "-a #@app_name"
        end

        options.join(" ")
      end
    end
  end
end
