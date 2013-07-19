Gem::Specification.new do |spec|
  spec.name		= "test-ally"
  spec.version		= "0.0.1"
  author_list = {
    "Judson Lester" => 'nyarly@gmail.com'
  }
  spec.authors		= author_list.keys
  spec.email		= spec.authors.map {|name| author_list[name]}
  spec.summary		= "Tools to smooth development"
  spec.description	= <<-EndDescription
  Three things:

  An rspec formatter that triggers libnotify on completion.
  An rspec formatter that outputs to vim quickfix
  A simplecov formatter that produces vim markers (+ a vim plugin to load them)
  EndDescription

  spec.rubyforge_project= spec.name.downcase
  spec.homepage        = "http://nyarly.github.com/#{spec.name.downcase}"
  spec.required_rubygems_version = Gem::Requirement.new(">= 0") if spec.respond_to? :required_rubygems_version=

  # Do this: y$@"
  # !!find default_files lib bin doc spec spec_help -not -regex '.*\.sw.' -type
    # f 2>/dev/null
  spec.files		= %w[
    lib/test-ally/libnotify/notifier.rb
    lib/test-ally/growl/notifier.rb
    lib/test-ally/rspec/quickfix.rb
    lib/test-ally/rspec/true-feelings.rb
    lib/test-ally/rspec/alert-after-running.rb
    lib/test-ally/config.rb
    lib/test-ally/command-line.rb
    lib/test-ally/valise.rb
    lib/test-ally/simplecov/vim-formatter.rb
    bin/test-ally
    default_files/config.yaml
    default_files/templates/simplecov-config
    default_files/templates/plugin.vim
    default_files/templates/coverage-results.vim.erb
    default_files/templates/rspec-config
    spec/simplecov/formatter.rb
  ]

  spec.test_file        = "spec_help/gem_test_suite.rb"
  spec.licenses = ["MIT"]
  spec.require_paths = %w[lib/]
  spec.rubygems_version = "1.3.5"

  spec.executables = %w{test-ally}

  spec.has_rdoc		= true
  spec.extra_rdoc_files = Dir.glob("doc/**/*")
  spec.rdoc_options	= %w{--inline-source }
  spec.rdoc_options	+= %w{--main doc/README }
  spec.rdoc_options	+= ["--title", "#{spec.name}-#{spec.version} Documentation"]

  spec.add_dependency("thor", "~> 0.18.1")
  spec.add_dependency("tilt", "~> 1.4.1")
  spec.add_dependency("valise", "~> 0.9")

  #spec.post_install_message = "Thanks for installing my gem!"
end
