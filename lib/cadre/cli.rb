require 'thor'
require 'test-ally/valise'

module TestAlly
  class Cli < Thor
    def how_to
      puts <<-EOH
      This is a set of tools for aiding development - to integrate testing and
      metrics with editors and notifications.

      Try:
      #{$0} vim_plugin > ~/.vim/plugin/test_ally.vim
      #{$0} rspec_config >> .rspec
      #{$0} simplecov_config >> .simplecov

      Yeah, that's three commands, and you have to do the redirects yourself,
      but you can review the output before making it live, and put them
      somewhere else if that's what you want.
      EOH
    end

    def vim_plugin
      puts TestAlly::Valise.contents["templates/plugin.vim"]
    end
  end
end
