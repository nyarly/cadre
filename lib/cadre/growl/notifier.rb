require 'cadre/notifier'

module Cadre
  module Growl
    class Notifier < ::Cadre::Notifier
      register :growl

      def self.available?
        #XXXX This isn't going to work at all as is. Lifted from other code, as #ok
        #hints toward a working adapter
        availables["growlnotify"]
      end

      def go
#        growlnotify "--image ./autotest/fail.png -p Emergency -m '#{summary}' -t '#{message}'" #ok
#        growlnotify "--image ./autotest/pending.png -p High -m '#{summary}' -t '#{message}'" #ok
#        growlnotify "--image ./autotest/pass.png -p 'Very Low' -m '#{summary}' -t '#{message}'" #ok
        growlnotify "-m '#{summary}' -t '#{message}'" #ok
      end

      def growlnotify str
        system "growlnotify -n cadre #{str}"
      end

    end
  end
end
