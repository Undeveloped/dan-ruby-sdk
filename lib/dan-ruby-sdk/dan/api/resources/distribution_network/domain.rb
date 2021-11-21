module Dan
  module Api
    module Resources
      module DistributionNetwork
        class Domain < ::Dan::Api::Resources::Base
          ATTRIBUTES = %i[id name options].freeze
          attr_reader(*ATTRIBUTES)
        end
      end
    end
  end
end
