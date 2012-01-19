module Verver
  class Document
    def initialize(template_path)
      @template = File.read(template_path)
    end

    def interpolate
      @template
    end
  end
end
