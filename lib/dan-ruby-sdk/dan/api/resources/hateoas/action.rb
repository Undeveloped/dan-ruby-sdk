module Dan
  module Api
    module Resources
      module Hateoas
        class Action
          attr_reader :client, :resource, :method, :href, :params

          ARG_MAP = {
            'integer' => Integer,
            'string' => String
          }

          def initialize(client, resource, args = {})
            @client = client
            @resource = resource
            @method = args['method']
            @href = args['href']
            @params = args['params']
          end

          def call(args = {})
            client.authenticated do
              client.request(method, href, args.slice(*params.keys), true)

              resource.get
            end
          end
        end
      end
    end
  end
end
