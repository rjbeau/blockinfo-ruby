module Crypto
  class Bkchain

    def connection
      @connection = Faraday.new(url: 'http://bkchain.org') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        # faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def info(currency_code, address)
      response = connection.get "#{currency_code}/api/v1/address/balance/#{address}"
      array = JSON.parse response.body
      array[0]
    end

  end

end
