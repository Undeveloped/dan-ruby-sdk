module Dan
  module Api
    module Resources
      class Orders
        include ::Dan::Api::Resources::List

        BASE_URL = 'orders'.freeze

        def create(params = {})
          client.authenticated do
            response = client.request(
              :post,
              BASE_URL,
              params
            )
            Order.new(client, JSON.parse(response.body)['order'])
          end
        end

        def get(id)
          client.authenticated do
            response = client.request(:get, "#{BASE_URL}/#{id}")
            order = JSON.parse(response.body)['order']
            Order.new(
              client,
              order.slice(*Order::ATTRIBUTES.map(&:to_s))
            )
          end
        end

        def all
          clear

          client.authenticated do
            response = client.request(:get, BASE_URL)
            JSON.parse(response.body)['orders'].each do |order|
              self << Order.new(
                client,
                order.slice(*Order::ATTRIBUTES.map(&:to_s))
              )
            end
          end

          self
        end
      end
    end
  end
end
