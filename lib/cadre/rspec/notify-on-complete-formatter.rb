require 'cadre/notifier'
require 'rspec/core/formatters/base_formatter'

rspec_pid = Process.pid
at_exit do
  if Process.pid == rspec_pid and not($!.nil? or $!.is_a?(SystemExit))
    message =  "Exception:\n#{$!.inspect}\n#{Dir.pwd}"
    Cadre::Libnotify::Notifier.new do |notifier|
      notifier.summary = "Spec run exited unexpectedly"
      notifier.message = message
      notifier.expire_time = 5000
      notifier.sound = "error"
    end.go
  end
end

module Cadre
  module RSpec
    class NotifyOnCompleteFormatter < ::RSpec::Core::Formatters::BaseFormatter
      def notify_message(duration, example_count, failure_count, pending_count)
        "Total duration: #{duration}\n Total: #{example_count}\n Failed: #{failure_count}\n Pending: #{pending_count}\n\nFinished at #{Time.now}"
      end

      def dump_summary(duration, example_count, failure_count, pending_count)
        notifier = Cadre::Notifier.get.new

        if duration < 20
          notifier.transient = true
          notifier.summary = "Finished spec run"
          notifier.message = notify_message(duration, example_count, failure_count, pending_count)
        else
          notifier.summary = "Finished long spec run"
          notifier.message = notify_message(duration, example_count, failure_count, pending_count)
        end
        if failure_count > 0
          notifier.sound = "failure"
        else
          notifier.sound = "success"
        end
        notifier.go
      end
    end
  end
end
