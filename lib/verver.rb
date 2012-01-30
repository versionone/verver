require "verver/version"

module Verver
  class Error < RuntimeError; end

  def self.root
    original_dir
  end

  private

  def self.original_dir
    ROOT
  end

  ROOT = Dir.pwd
end
