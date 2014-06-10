require 'cadre/simplecov'

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Cadre::SimpleCov::VimFormatter
  ]
  coverage_dir "corundum/docs/coverage"
  add_filter "./spec"
  add_filter "vendor"
end
