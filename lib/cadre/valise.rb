require 'valise'

module Cadre
  def self.build_valise
    Valise.define do
      rw ".cadre"
      rw "~/.cadre"
      rw "/usr/share/cadre"
      rw "/etc/cadre"
      ro up_to("lib") + "/../default_files"

      handle "*.yaml", :yaml, :hash_merge
    end
  end

  Valise = build_valise
end
