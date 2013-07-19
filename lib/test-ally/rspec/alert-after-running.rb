require 'test-ally/libnotify/notifier'

rspec_pid = Process.pid
at_exit do
  if Process.pid == rspec_pid and not($!.nil? or $!.is_a?(SystemExit))
    message =  "Exception:\n#{$!.inspect}\n#{Dir.pwd}"
    TestAlly::Libnotify::Notifier.new do |notifier|
      notifier.summary = "Spec run exited unexpectedly"
      notifier.message = message
      notifier.expire_time = 5000
      notifier.sound = "error.ogg"
    end.go
  end
end

module TestAlly
  module RSpec
    class LibnotifyFormatter < ::RSpec::Core::Formatters::BaseFormatter
      def notify_message(duration, example_count, failure_count, pending_count)
        "Total duration: #{duration}\n Total: #{example_count}\n Failed: #{failure_count}\n Pending: #{pending_count}\n\nFinished at #{Time.now}"
      end

      def dump_summary(duration, example_count, failure_count, pending_count)
        notifier = Libnotify::Notifier.new
        if duration < 20
          notifier.transient = true
          notifier.summary = "Finished spec run"
          notifier.message = notify_message(duration, example_count, failure_count, pending_count)
          notifier.sound = "failure.wav" if failure_count > 0
        else
          notifier.summary = "Finished long spec run"
          notifier.message = notify_message(duration, example_count, failure_count, pending_count)
          if failure_count > 0
            notifier.sound = "failure.wav"
          else
            notifier.sound = "success.ogg"
          end
        end
        notifier.go
      end
    end
  end
end
