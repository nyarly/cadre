require 'fileutils'

module FileSandbox
  def self.included(spec)
    return unless spec.respond_to? :before

    spec.before do
      setup_sandbox
    end

    spec.after do
      teardown_sandbox
    end
  end

  class HaveContents
    def initialize(contents)
      @contents = contents
    end

    def matches?(target)
      case @contents
      when Regexp
	@contents =~ target.contents
      when String
	@contents == target.contents
      end
    end
  end

  def have_contents(expected)
    HaveContents.new(expected)
  end

  attr_reader :sandbox

  def in_sandbox(&block)
    raise "I expected to create a sandbox as you passed in a block to me" if !block_given?

    setup_sandbox
    original_error = nil

    begin
      yield @sandbox
    rescue => e
      original_error = e
      raise
    ensure
      begin
        teardown_sandbox
      rescue
        if original_error
          STDERR.puts "ALERT: a test raised an error and failed to release some lock(s) in the sandbox directory"
          raise(original_error)
        else
          raise
        end
      end
    end
  end

  def setup_sandbox(path = '__sandbox')
    unless @sandbox
      @sandbox = Sandbox.new(path)
      @__old_path_for_sandbox = Dir.pwd
      Dir.chdir(@sandbox.root)
    end
  end

  def teardown_sandbox
    if @sandbox
      Dir.chdir(@__old_path_for_sandbox)
      @sandbox.clean_up
      @sandbox = nil
    end
  end

  class Sandbox
    attr_reader :root

    def initialize(path = '__sandbox')
      @root = File.expand_path(path)
      clean_up
      FileUtils.mkdir_p @root
    end

    def [](name)
      SandboxFile.new(File.join(@root, name), name)
    end

    # usage new :file=>'my file.rb', :with_contents=>'some stuff'
    def new(options)
      if options.has_key? :directory
        dir = self[options.delete(:directory)]
        FileUtils.mkdir_p dir.path
      else
        file = self[options.delete(:file)]
        if (binary_content = options.delete(:with_binary_content) || options.delete(:with_binary_contents))
          file.binary_content = binary_content
        else
          file.content = (options.delete(:with_content) || options.delete(:with_contents) || '')
        end
      end

      raise "unexpected keys '#{options.keys.join(', ')}'" unless options.empty?

      dir || file
    end

    def remove(options)
      name = File.join(@root, options[:file])
      FileUtils.remove_file name
    end

    def clean_up
      FileUtils.rm_rf @root
      if File.exists? @root
        raise "Could not remove directory #{@root.inspect}, something is probably still holding a lock on it"
      end
    end
  end


  class SandboxFile
    attr_reader :path

    def initialize(path, sandbox_path)
      @path = path
      @sandbox_path = sandbox_path
    end

    def inspect
      "SandboxFile: #@sandbox_path"
    end

    def exist?
      File.exist? path
    end

    def content
      File.read path
    end

    def content=(content)
      FileUtils.mkdir_p File.dirname(@path)
      File.open(@path, "w") {|f| f << content}
    end

    def binary_content=(content)
      FileUtils.mkdir_p File.dirname(@path)
      File.open(@path, "wb") {|f| f << content}
    end

    def create
      self.content = ''
    end

    alias exists? exist?
    alias contents content
    alias contents= content=
    alias binary_contents= binary_content=
  end
end
