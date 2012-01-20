require "verver/version"
require "rake"

module Verver
  def self.root
    Rake.application.original_dir
  end
end
