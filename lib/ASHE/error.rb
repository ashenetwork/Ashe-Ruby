module ASHE
  class ASHEError < StandardError
    attr_reader :message
    attr_reader :code

    def initialize(message, code="0")
      @message = message
      @code = code
    end
  end
end
