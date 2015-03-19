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
      @ltcblockr_connection = Faraday.new(url: 'http://ltc.blockr.io') do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
      @dogechain_connection = Faraday.new(url: 'https://dogechain.info') do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end

    def connection(currency)
      case currency
      when 'xbt', 'btc'
        @blockchain_connection
      when 'ltc'
        @ltcblockr_connection
      when 'xdg'
        @dogechain_connection
      else
        @bkchain_connection
      end
    end

    def blockchain_path(address)
      "address/#{address}?format=json"
    end

    def bkchain_path(currency_code, address)
      currency_code = 'doge' if currency_code == 'xdg'
      "#{currency_code}/api/v1/address/balance/#{address}"
    end

    def ltcblockr_path(address)
      "api/v1/address/txs/#{address}"
    end

    def dogechain_path(address)
      "api/v1/address/balance/#{address}"
    end

    def info(currency, address, existing_txns=0)
      case currency
      when 'xbt', 'btc'
        response = connection(currency).get blockchain_path(address)
        json = JSON.parse response.body
        {
          balance: json['final_balance'].to_i,
          txns: json['n_tx'].to_i
        }
      when 'ltc'
        response = connection(currency).get ltcblockr_path(address)
        json = JSON.parse response.body
        amt = 0.0
        json['data']['txs'].each { |t| amt += t['amount'].to_f }
        {
          balance: amt.round(8),
          txns: json['data']['nb_txs']
        }        
      when 'xdg'
        # dogechain.info doesn't supply # of txns with balance.
        # existing_txns passed in is a HACK so we know if there have been txns when balance = 0 (i.e. swept)
        response = connection(currency).get dogechain_path(address)
        json = JSON.parse response.body
        amt = json['balance'].to_f
        if amt == 0.0
          existing_txns > 0 ? txns = existing_txns + 1 : txns = 0
        else
          txns = 1          
        end
        {
          balance: amt.round(8),
          txns: txns
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
