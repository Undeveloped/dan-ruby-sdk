module Dan
  module Api
    module Resources
      class Client < Base
        ATTRIBUTES = %i[
          address1 address2 billing_name city client_type
          company country_code dan_distribution_network_id
          billing_email phone vat_number zip
          payout_method bank_accounts paypal_accounts
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
