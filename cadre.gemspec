Gem::Specification.new do |spec|
  spec.name		= "cadre"
   #{MAJOR: incompatible}.{MINOR added feature}.{PATCH bugfix}-{LABEL}
  spec.version		= "0.2.2"
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
  # !!find default_files lib bin doc spec spec_help -not -regex '.*\.sw.' -type f 2>/dev/null
  spec.files		= %w[
    default_files/config.yaml
    default_files/sounds/error
    default_files/sounds/failure
    default_files/sounds/success
    default_files/templates/plugin.vim
    default_files/templates/coverage-results.vim.erb
    default_files/templates/simplecov-config
    default_files/templates/rspec-config
    lib/cadre/libnotify/notifier.rb
    lib/cadre/growl/notifier.rb
    lib/cadre/rspec.rb
    lib/cadre/rspec/quickfix-formatter.rb
    lib/cadre/rspec/notify-on-complete-formatter.rb
    lib/cadre/rspec/true-feelings-formatter.rb
    lib/cadre/config.rb
    lib/cadre/command-line.rb
    lib/cadre/valise.rb
    lib/cadre/notifier.rb
    lib/cadre/simplecov/vim-formatter.rb
    lib/cadre/simplecov.rb
    bin/cadre
    spec/simplecov/formatter.rb
    spec_help/gem_test_suite.rb
  ]

  spec.test_file        = "spec_help/gem_test_suite.rb"
  spec.licenses = ["MIT"]
  spec.require_paths = %w[lib/]
  spec.rubygems_version = "1.3.5"

  spec.executables = %w{cadre}

  spec.has_rdoc		= true
  spec.extra_rdoc_files = Dir.glob("doc/**/*")
  spec.rdoc_options	= %w{--inline-source }
  spec.rdoc_options	+= %w{--main doc/README }
  spec.rdoc_options	+= ["--title", "#{spec.name}-#{spec.version} Documentation"]

  spec.add_dependency("thor", ">= 0.18.1", "< 1.0")
  spec.add_dependency("tilt", "~> 1.0")
  spec.add_dependency("valise", "~> 1.0")

  #spec.post_install_message = "Thanks for installing my gem!"
end
