require 'cadre/valise'
require 'cadre/config'

module Cadre
  module Libnotify
    class Notifier < ::Cadre::Notifier
      register :libnotify

      def sound_enabled?
        @sound_enabled ||= Config.new(Valise, "libnotify").sound?
      end

      def self.available?
        return availables["notify-send"]
      end

      def go
        cmd = "notify-send #{options} \"#@summary\" \"#@message\""
        %x[#{cmd}]

        if sound_enabled? && String === sound
          filename = Valise.find(["sounds", sound]).full_path
          if available?("paplay")
            %x[paplay #{filename}]
          elsif available?("aplay")
            %x[aplay #{filename}]
          end
        end
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
