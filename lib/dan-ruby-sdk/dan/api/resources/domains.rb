module Dan
  module Api
    module Resources
      class Domains
        include ::Dan::Api::Resources::List

        BASE_URL = 'domains'.freeze

        def get(name)
          client.authenticated do
            response = client.request(:get, "#{BASE_URL}/#{name}")
            response = JSON.parse(response.body)['domain']
            Domain.new(
              response,
              response.slice(*Domain::ATTRIBUTES.map(&:to_s))
            )
          end
        end

        def all
          clear

          client.authenticated do
            response = client.request(:get, BASE_URL)
            JSON.parse(response.body)['domains'].each do |domain|
              self << Domain.new(
                client,
                domain.slice(*Domain::ATTRIBUTES.map(&:to_s))
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
            Domain.new(client, JSON.parse(response.body)['domain'])
          end
        end
      end
    end
  end
end
