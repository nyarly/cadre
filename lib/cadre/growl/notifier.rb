module Cadre
  module Growl
    #XXXX This isn't going to work at all as is. Lifted from other code, as
    #hints toward a working adapter
    class Notifier
      def close
        super
        summary = summary_line example_count, failure_count, pending_count
        if failure_count > 0
          growlnotify "--image ./autotest/fail.png -p Emergency -m '#{summary}' -t 'Spec failure detected'"
        elsif pending_count > 0
          growlnotify "--image ./autotest/pending.png -p High -m '#{summary}' -t 'Pending spec(s) present'"
        else
          growlnotify "--image ./autotest/pass.png -p 'Very Low' -m '#{summary}' -t 'All specs passed'"
        end
      end

      def growlnotify str
        system 'which growlnotify > /dev/null'
        if $?.exitstatus == 0
          system "growlnotify -n autotest #{str}"
        end
      end

    end
  end
end
