require "verver/version"

module Verver
  def self.root
    original_dir
  end

  private

  def self.original_dir
    ROOT
  end

  ROOT = Dir.pwd
end
