require 'simplecov'
require 'file-sandbox'
require 'cadre/simplecov/vim-formatter'

describe Cadre::SimpleCov::VimFormatter do
  include FileSandbox

  let :files do
    sandbox.new :directory => "lib/nested"
    [sandbox.new(:file => "lib/pretend_file"), sandbox.new(:file => "lib/nested/pretend_file")]
  end

  let :original_result do
    files.each_with_object({}) do |file, hash|
      hash[file.path] = [1,1,1,1]
    end
  end

  let :result do
    SimpleCov::Result.new(original_result)
  end

  let :formatter do
    described_class.new
  end

  it "should have an original result with absolute paths" do
    original_result.keys.each do |path|
      path.should =~ %r{\A/}
    end
  end

  it "should produce a vimscript" do
    formatter.format(result)
    File::exists?(".cadre/coverage.vim").should be_true

    File::open(".cadre/coverage.vim") do |scriptfile|
      lines = scriptfile.each_line
      lines.grep(/(['"])pretend_file\1/).should_not == []
      scriptfile.rewind
      lines.grep(%r[(['"])nested/pretend_file\1]).should_not == []
    end
  end
end
