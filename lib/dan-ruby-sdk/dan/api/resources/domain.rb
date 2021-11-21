module Dan
  module Api
    module Resources
      class Domain < Base
        ATTRIBUTES = %i[
          id name stem tld buy_now_price starting_offer
          client_dan_distribution_network_id currency_code status
        ].freeze
        attr_reader(*ATTRIBUTES)

        def get
          assign(client.domains.get(name))
        end

        def url
          "#{Domains::BASE_URL}/#{name}"
        end

        def delete(params = {})
          client.authenticated do
            client.request(
              :delete,
              url,
              params
            )

            true
          end
        end
      end
    end
  end
end
