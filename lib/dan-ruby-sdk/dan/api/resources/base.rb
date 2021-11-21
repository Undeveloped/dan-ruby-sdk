module Dan
  module Api
    module Resources
      class Base
        attr_reader :client, :parent

        def initialize(client, params = {}, parent = nil)
          @client = client
          @parent = parent
          params.each do |name, value|
            instance_variable_set("@#{name}", value)
          end
        end

        def assign(object)
          self.class::ATTRIBUTES.each do |name|
            instance_variable_set("@#{name}", object.send(name))
          end

          self
        end

        def url
          raise NotImplementedError
        end

        def to_json(_options = nil)
          hash = {}

          self.class::ATTRIBUTES.each do |name|
            hash[name.to_s] = instance_variable_get("@#{name}")
          end

          hash.to_json
        end
      end
    end
  end
end

require_relative 'list'
require_relative 'distribution_network/listings'
require_relative 'distribution_network/listing'
require_relative 'distribution_network/domains'
require_relative 'distribution_network/domain'
require_relative 'clients'
require_relative 'client'
require_relative 'client/bank_account'
require_relative 'client/bank_accounts'
require_relative 'client/paypal_account'
require_relative 'client/paypal_accounts'
require_relative 'conversations'
require_relative 'conversation'
require_relative 'orders'
require_relative 'order'
require_relative 'domains'
require_relative 'domain'
require_relative 'hateoas/action'
require_relative 'sandbox/action'
