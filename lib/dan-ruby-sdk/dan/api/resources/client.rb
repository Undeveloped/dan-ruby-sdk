module Dan
  module Api
    module Resources
      class Client < Base
        ATTRIBUTES = %i[
          address1 address2 bank_code bank_name billing_name city client_type
          company country country_code currency_code dan_distribution_network_id
          email display_name iban_number phone registration vat_number zip
          payout_method bank_accounts
        ].freeze
        attr_reader(*ATTRIBUTES)

        def get
          assign(client.clients.get(dan_distribution_network_id))
        end

        def update(params = {})
          client.authenticated do
            response = client.request(
              :put,
              url,
              params
            )
            assign(::Dan::Api::Resources::Client.new(client, JSON.parse(response.body)['client']))
          end
        end

        def url
          "#{Clients::BASE_URL}/#{dan_distribution_network_id}"
        end

        def bank_accounts
          BankAccounts.new(client, [], self)
        end

        def paypal_accounts
          PaypalAccounts.new(client, [], self)
        end
      end
    end
  end
end
