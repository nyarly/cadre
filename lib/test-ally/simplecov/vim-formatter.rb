require 'test-ally/config'
require 'test-ally/valise'

module TestAlly
  module SimpleCov
    class VimFormatter
      class << self
        attr_accessor :options
      end
      @options = {verbose: false, output_path: "coverage.vim"}

      # call with VimFormatter.with_options(...) to get a VimFormatter class
      def self.with_options(options)
        merged_options = self.options.merge(options)
        return Class.new(self) { @options = merged_options }
      end

      def initialize
        @options = Config.new(Valise, "simplecov")
      end
      attr_reader :options

      Scope = Struct.new(:results)

      def format(result)
        scope = Scope.new({})
        dir_re = /^#{common_directory(result.filenames)}\//
          result.filenames.zip(result.original_result.values_at(*result.filenames)).each do |name, lines|

          scope.results[name.sub(dir_re, "")] = file_results = {:ignored => [], :hits => [], :misses => []}
          lines.each_with_index do |hits, line|
            case hits
            when nil
              file_results[:ignored] << line + 1
            when 0
              file_results[:misses] << line + 1
            else
              file_results[:hits] << line + 1
            end
          end
          end

        coverage_output = options.output_path

        write_file("coverage-results.vim", coverage_output, scope)
        puts "Wrote vim coverage script to #{coverage_output}" unless options.quiet?
      end

      def common_directory(files)
        File::join(files.map{|file| file.split(File::Separator)}.inject do |dir, path|
          dir.zip(path).take_while{|l,r| l == r}.map{|l,_| l}
        end)
      end

      def templates
        @templates ||= Valise.templates
      end

      def write_file(template_name, output_filename, bound)
        content = templates.find(template_name).contents.render(bound)
        File.open( output_filename, "w" ) do |file_result|
          file_result.write content
        end
      end
    end
  end
end
