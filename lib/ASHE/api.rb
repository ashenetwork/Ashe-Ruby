require 'json'
require 'rest_client'

module ASHE
  class API
    VERSION = '1'
    BASE_URL = 'https://www.ashepay.com'

    def self.mode=(mode)
      @mode = mode
    end

    def self.merchant_id=(merchant_id)
      @merchant_id = merchant_id
    end

    def self.private_key=(private_key)
      @private_key = private_key
    end

    def self.post_request(params=nil, method=nil)
      check_params(params, method)
      data = build_url(method)
      data = build_headers(data)
      data[:payload] = build_private_data(params).to_json
      begin
        response = RestClient::Request.execute(data)
        response = JSON.parse(response)
      rescue 
        raise ASHEError.new("Could not connect to the server. Please check your internet connection.", "E500")
      end
      if response["errors"] and response["errors"][0]
        error = response["errors"][0]
        raise ASHEError.new(error["msg"], error["code"])
      end
      return response
    end

    private

    def self.check_params(params, method)
      if ['charge', 'refund'].include? method == false
        raise "Unknown method."
      end
      if !@merchant_id
        raise ASHEError.new("Invalid merchant id.", "E402")
      end
      if !@private_key
        raise ASHEError.new("Invalid private key.", "E402")
      end
      if ['sandbox', 'production'].include? @mode == false
        raise ASHEError.new("Invalid mode. Please specify either 'production' or 'sandbox'.", "E402")
      end
      if !params[:amount]
        raise ASHEError.new("Invalid amount.", "E401")
      end
      if method == 'charge' and !params[:token]
        raise ASHEError.new("Invalid token.", "E401")
      end
      if method == 'refund' and !params[:transaction_id]
        raise ASHEError.new("Invalid transaction id.", "E401")
      end
    end

    def self.build_url(method)
      data = {:method => :post}
      if method == 'charge'
        if @mode == 'production'
          data[:url] = "%s/api/payment/v1/%s/" % [BASE_URL, @merchant_id]
        else
          data[:url] = "%s/api/sandbox/%s/" % [BASE_URL, @merchant_id]
        end
      elsif method == 'refund'
        if @mode == 'production'
          data[:url] = "%s/api/refund/v1/%s/" % [BASE_URL, @merchant_id]
        else
          data[:url] = "%s/api/sandbox/refund/%s/" % [BASE_URL, @merchant_id]
        end
      end
      return data
    end

    def self.build_headers(data)
      data[:headers] = {
        :accept => :json,
        :user_agent => 'ASHE Corporation Ruby Payment API V%s' % VERSION,
        :content_type => :json
      }
      return data
    end

    def self.build_private_data(params)
      params[:merchant_id] = @merchant_id
      params[:private_key] = @private_key
      return params
    end

  end
end
