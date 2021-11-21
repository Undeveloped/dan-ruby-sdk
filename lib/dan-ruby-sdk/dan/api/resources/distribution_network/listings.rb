module Dan
  module Api
    module Resources
      module DistributionNetwork
        class Listings
          include ::Dan::Api::Resources::List

          BASE_URL = 'distribution_network/listings'.freeze

          def create(params = {})
            client.authenticated do
              response = client.request(
                :post,
                BASE_URL,
                params
              )
              Listing.new(client, JSON.parse(response.body)['listing'])
            end
          end

          def all
            clear

            client.authenticated do
              response = client.request(:get, BASE_URL)
              JSON.parse(response.body)['listings'].each do |listing|
                self << Listing.new(
                  client,
                  listing.slice(*Listing::ATTRIBUTES.map(&:to_s))
                )
              end
            end

            self
          end
        end
      end
    end
  end
end
