module Dan
  module Api
    module Resources
      class Conversations
        include ::Dan::Api::Resources::List

        BASE_URL = 'conversations'.freeze

        def create(params = {})
          client.authenticated do
            response = client.request(
              :post,
              BASE_URL,
              params
            )
            Conversation.new(client, JSON.parse(response.body)['conversation'])
          end
        end

        def get(token)
          client.authenticated do
            response = client.request(:get, "#{BASE_URL}/#{token}")
            conversation = JSON.parse(response.body)['conversation']
            Conversation.new(
              client,
              conversation.slice(*Conversation::ATTRIBUTES.map(&:to_s))
            )
          end
        end

        def all
          clear

          client.authenticated do
            response = client.request(:get, BASE_URL)
            JSON.parse(response.body)['conversations'].each do |conversation|
              self << Conversation.new(
                client,
                conversation.slice(*Conversation::ATTRIBUTES.map(&:to_s))
              )
            end
          end

          self
        end
      end
    end
  end
end
