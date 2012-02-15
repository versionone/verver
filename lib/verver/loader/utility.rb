module Verver
  module Loader
    module Utility

      def meta_friendly_name(name)
        stringified = name.to_s
        return stringified.sub(/(^.)/) {|capture| capture.upcase} unless stringified.include?('_')
        stringified.split('_').map { |part| part.sub(/(^.)/) {|capture| capture.upcase} }.join
      end

      def ruby_friendly_name(name)
        return name if /^[a-z_]*$/ =~ name
        name.to_s.gsub(/[A-Z]/) {|s| '_' + s.to_s.downcase}.gsub(/\./,'').sub('_','')
      end

    end
  end
end

