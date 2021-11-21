module Dan
  module Api
    module Resources
      class Conversation < Base
        ATTRIBUTES = %i[id client_id name phone email buyer_type company_name domain_name token vat_option conversation_state transaction_state links].freeze
        attr_reader(*ATTRIBUTES)

        def get
          assign(client.conversations.get(token))
        end

        def url
          "#{Conversations::BASE_URL}/#{token}"
        end

        def sandbox
          raise ::Dan::Api::InvalidEnvironmentError unless client.environment == :sandbox

          OpenStruct.new(
            payment_received: Sandbox::Action.new(client, self, :payment_received, :put),
            transaction_cancelled: Sandbox::Action.new(client, self, :transaction_cancelled, :put),
            account_change_initiated: Sandbox::Action.new(client, self, :account_change_initiated, :put),
            domain_transferred: Sandbox::Action.new(client, self, :domain_transferred, :put),
          )
        end

        def seller_actions
          actions = {}
          links["seller_actions"].each_pair do |action_name, action|
            actions[action_name] = Hateoas::Action.new(client, self, action)
          end

          OpenStruct.new(actions)
        end

        def buyer_actions
          actions = {}
          links["buyer_actions"].each_pair do |action_name, action|
            actions[action_name] = Hateoas::Action.new(client, self, action)
          end

          OpenStruct.new(actions)
        end
      end
    end
  end
end
