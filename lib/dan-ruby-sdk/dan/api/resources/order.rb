module Dan
  module Api
    module Resources
      class Order < Base
        ATTRIBUTES = %i[
          id price company status address1 address2 zip city country_code vat_rate
          vat total currency_code vat_option vat_number token paid_at created_at state
          checkout_url domain_name transaction_state conversation_token
        ].freeze
        attr_reader(*ATTRIBUTES)

        def get
          assign(client.orders.get(id))
        end

        def url
          "#{Orders::BASE_URL}/#{id}"
        end
      end
    end
  end
end
