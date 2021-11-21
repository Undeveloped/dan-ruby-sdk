module Dan
  module Api
    module Resources
      class Clients
        include ::Dan::Api::Resources::List

        BASE_URL = 'clients'.freeze

        def get(dan_distribution_network_id)
          client.authenticated do
            response = client.request(:get, "#{BASE_URL}/#{dan_distribution_network_id}")
            response = JSON.parse(response.body)['client']
            Client.new(
              client,
              response.slice(*Client::ATTRIBUTES.map(&:to_s))
            )
          end
        end

        def all
          clear

          client.authenticated do
            response = client.request(:get, BASE_URL)
            JSON.parse(response.body)['clients'].each do |response_client|
              self << Client.new(
                client,
                response_client.slice(*Client::ATTRIBUTES.map(&:to_s))
              )
            end
          end

          self
        end

        def create(params = {})
          client.authenticated do
            response = client.request(
              :post,
              BASE_URL,
              params
            )
            Client.new(client, JSON.parse(response.body)['client'])
          end
        end
      end
    end
  end
end
