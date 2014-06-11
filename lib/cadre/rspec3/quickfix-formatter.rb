# !!! Lifted wholesale from
# https://wincent.com/blog/running-rspec-specs-from-inside-vim
require 'rspec/core/formatters/base_text_formatter'
require 'cadre/config'

module Cadre
  module RSpec3
    class QuickfixFormatter

      # TODO: vim-side function for printing progress (if that's even possible)
      #
      def initialize(output)
        @config = Config.new(Valise, "quickfix")
        @output = File::open(@config.output_path, "w")
      end
      attr_reader :output, :config

      ::RSpec::Core::Formatters.register self, :example_failed, :example_pending

      def example_failed(notification)
        example = notification.example

        exception = example.execution_result.exception
        paths = exception.backtrace.map do |frame|
          format_caller frame
        end.compact
        paths = paths[0..config.backtrace_limit]
        message = "#{example.full_description}: #{format_message exception.message}"
        paths.each do |path|
          output.puts "#{path}: [FAIL] #{message}"
        end
      end

      def example_pending(example)
        return unless config.include_pending?
        example = notification.example

        message = format_message example.execution_result[:pending_message]
        path    = format_caller example.location
        output.puts "#{path}: [PEND] #{message}" if path
      end

      def dump_summary(duration, example_count, failure_count, pending_count)
        @duration = duration
        @example_count = example_count
        @failure_count = failure_count
        @pending_count = pending_count
      end

      private

      def format_caller(caller_info)
        RSpec.configuration.backtrace_formatter.backtrace_line(caller_info.to_s.split(':in `block').first)
      end

      def format_message(msg)
        # NOTE: may consider compressing all whitespace here
        msg.gsub("\n", ' ')[0,40]
      end
    end
  end
end
