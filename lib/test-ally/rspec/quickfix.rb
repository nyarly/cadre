# !!! Lifted wholesale from
# https://wincent.com/blog/running-rspec-specs-from-inside-vim
require 'rspec/core/formatters/base_text_formatter'
require 'test-ally/config'

module TestAlly
  module RSpec
    class QuickfixFormatter < ::RSpec::Core::Formatters::BaseTextFormatter

      # TODO: vim-side function for printing progress (if that's even possible)
      #
      def initialize(output)
        super(output)
        @config = Config.new(Valise, "quickfix")
        @output = File::open(@config.output_path, "w")
      end
      attr_reader :config

      def example_failed(example)
        exception = example.execution_result[:exception]
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
        message = format_message example.execution_result[:pending_message]
        path    = format_caller example.location
        output.puts "#{path}: [PEND] #{message}" if path
      end

      def dump_failures(*args); end

      def dump_pending(*args); end

      def message(msg); end

      def dump_summary(duration, example_count, failure_count, pending_count)
        @duration = duration
        @example_count = example_count
        @failure_count = failure_count
        @pending_count = pending_count
      end

      private

      def format_message(msg)
        # NOTE: may consider compressing all whitespace here
        msg.gsub("\n", ' ')[0,40]
      end
    end
  end
end
