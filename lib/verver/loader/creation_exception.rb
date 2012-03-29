module Verver
 module Loader

  class CreationException

    attr_accessor :response

    def initialize(response)
      @response = response
    end

  end

 end
end
