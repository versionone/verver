module Verver
  module Loader
    module Utility

      def meta_friendly_name(name)
        stringified = name.to_s
        return stringified.sub(/(^.)/) { |capture| capture.upcase } unless stringified.include?('_')
        stringified.split('_').map { |part| part.sub(/(^.)/) { |capture| capture.upcase } }.join
      end

      def ruby_friendly_name(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/::/, '/')
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.gsub!(/[-.:]/, "_")
        word.downcase!
        word
      end

    end
  end
end

