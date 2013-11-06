require 'cadre/valise'

module Cadre
  module Libnotify
    class Notifier < ::Cadre::Notifier
      register :libnotify

      def self.available?
        return availables["notify-send"]
      end

      def go
        cmd = "notify-send #{options} \"#@summary\" \"#@message\""
        %x[#{cmd}]

        if available?("paplay")
          %x[paplay #{Valise.find(["sounds", sound]).full_path}] if String === sound
        elsif available?("aplay")
          %x[aplay #{Valise.find(["sounds", sound]).full_path}] if String === sound
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
