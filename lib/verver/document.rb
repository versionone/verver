require 'ostruct'
require 'erb'

module Verver
  class Document
    def initialize(template_path)
      contents = File.read(template_path)
      @template = ERB.new(contents)
    end

    def interpolate(replacements = {})
      locals = ErbBinding.new(replacements)
      @template.result(locals.get_binding)
    end

    private

    class ErbBinding < OpenStruct
      def get_binding
        return binding()
      end
    end
  end
end
