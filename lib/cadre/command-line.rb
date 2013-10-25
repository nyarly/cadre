require 'thor'
require 'cadre/valise'

module Cadre
  class CommandLine < Thor
    desc "how_to", "Short guide on usage"
    def how_to
      command_name = File::basename($0)
      puts <<-EOH
      This is a set of tools for aiding development - to integrate testing and
      metrics with editors and notifications.

      Try:
      #{command_name} vim_plugin > ~/.vim/plugin/cadre.vim
      #{command_name} rspec_config >> spec/spec_helper.rb
      #{command_name} simplecov_config >> .simplecov
      echo errors.err >> .gitignore
      echo .cadre >> .gitignore

      Yeah, that's five commands, and you have to do the redirects yourself,
      but you can review the output before making it live, and put them
      somewhere else if that's what you want. (I'm considering a single command for all of it...)

      Configuration (including tool config templates) is sourced from:
       #{Valise.to_s("\n       ")}
      EOH
    end

    desc "vim_plugin", "Outputs plugin for vim"
    def vim_plugin
      puts Valise.find("templates/plugin.vim").contents
    end

    desc "rspec_config","Outputs RSpec config"
    def rspec_config
      puts Valise.find("templates/rspec-config").contents
    end

    desc "simplecov_config", "Outputs Simplecov config"
    def simplecov_config
      puts Valise.find("templates/simplecov-config").contents
    end
  end
end
