module ASHE
  class Charge

    def self.charge(params={})
      response = ASHE::API.post_request(params, 'charge')
      return response
    end

    def self.refund(params={})
      response = ASHE::API.post_request(params, 'refund')
      return response
    end

  end
end
