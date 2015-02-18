module Crypto
  class Coin

    def initialize
      @blockchain_connection = Faraday.new(url: 'https://blockchain.info') do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      @bkchain_connection = Faraday.new(url: 'http://bkchain.org') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def connection(currency)
      return @blockchain_connection if %w(XBT BTC).include? currency.upcase
      @bkchain_connection
    end

    def blockchain_path(address)
      "address/#{address}?format=json"
    end

    def bkchain_path(currency_code, address)
      currency_code = 'doge' if currency_code == 'xdg'
      "#{currency_code}/api/v1/address/balance/#{address}"
    end

    def info(currency, address)
      case currency
      when 'xbt', 'btc'
        response = connection(currency).get blockchain_path(address)
        json = JSON.parse response.body
        {
          balance: json['final_balance'].to_i,
          txns: json['n_tx'].to_i
        }
      else
        response = connection(currency).get bkchain_path(currency, address)
        json = JSON.parse response.body
        {
          balance: json[0]['balance'].to_i,
          txns: json[0]['txcount'].to_i
        }
      end
    end

  end

end
