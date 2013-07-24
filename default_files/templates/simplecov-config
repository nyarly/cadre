require 'cadre/simplecov'

#SimpleCov.start 'rails' do #if, you know: Rails.
SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Cadre::SimpleCov::VimFormatter
  ]
end
