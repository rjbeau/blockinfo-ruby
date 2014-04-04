module Crypto
  class Bkchain


    def initialize
      @connection = Faraday.new(url: 'http://bkchain.org') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        # faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def connection
      @connection
    end


    def info(currency_code, address)
      response = connection.get "#{currency_code}/api/v1/address/balance/#{address}"
      array = JSON.parse response.body
      array[0]
    end

    def unspent(currency_code, address)
      response = connection.get "#{currency_code}/api/v1/address/unspent/#{address}"
      array = JSON.parse response.body
      unspent = array[0]['unspent']
      return { balance: 0 } if unspent.count == 0
      balance = 0
      unspent.each do |a|
        balance += Integer(a['v'])
      end
      { balance: balance }
    end

  end

end
