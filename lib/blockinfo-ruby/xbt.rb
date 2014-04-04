module Crypto
  class XBT

    def initialize
      @connection = Faraday.new(url: 'https://blockchain.info') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        # faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def connection
      @connection
    end

    def info(addr)
      response = connection.get "address/#{addr}?format=json"
      JSON.parse response.body
    end

    def brief_info(addr)
      response = connection.get "address/#{addr}?format=json"
      json = JSON.parse response.body
      {
        balance: json['final_balance'].to_i,
        txcount: json['n_tx'].to_i
      }
    end

    def balance(addr)
      response = connection.get "address/#{addr}?format=json"
      json = JSON.parse response.body
      json['final_balance'].to_i
    end

  end

end
