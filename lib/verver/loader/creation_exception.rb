module Verver
 module Loader

  class CreationException < StandardError

    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def to_s
      @response
    end

  end

 end
end
