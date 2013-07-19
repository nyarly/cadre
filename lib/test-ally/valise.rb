require 'valise'

module TestAlly
  def self.build_valise
    Valise.define do
      ro up_to("lib") + "/../default_files"

      handle "*.yaml", :yaml, :hash_merge
    end
  end

  Valise = build_valise
end
