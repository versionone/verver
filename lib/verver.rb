require "verver/version"
require "rake"

module Verver
  def self.rake_root
    Rake.application.original_dir
  end
end
