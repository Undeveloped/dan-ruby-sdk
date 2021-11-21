module Dan
  module Api
    module Resources
      module DistributionNetwork
        class Domains
          include ::Dan::Api::Resources::List

          BASE_URL = 'dp/demand/domains'.freeze

          def all(query="")
            clear

            client.authenticated do
              response = client.request(:get, "#{BASE_URL}?query=#{query}")
              JSON.parse(response.body)['results'].each do |domain|
                self << Domain.new(
                  client,
                  domain["domain"].slice(*Domain::ATTRIBUTES.map(&:to_s))
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
