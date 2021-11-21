module Dan
  module Api
    module Resources
      module DistributionNetwork
        class Listing < Dan::Api::Resources::Base
          ATTRIBUTES = %i[id buy_now_price starting_offer created_at max_lease_period checkout_url name].freeze
          attr_reader(*ATTRIBUTES)
        end
      end
    end
  end
end
