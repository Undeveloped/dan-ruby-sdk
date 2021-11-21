module Dan
  module Api
    module Resources
      module Hateoas
        class Action
          attr_reader :client, :resource, :method, :href, :params

          class InvalidParamError < StandardError; end

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
            validate_params!(args)

            client.authenticated do
              client.request(method, href, args, true)

              resource.get
            end
          end

          private

          def validate_params!(args)
            args.each_pair do |key, value|
              validate_param!(key, value)
            end
          end

          def validate_param!(key, value)
            raise InvalidParamError unless params[key]

            raise InvalidParamError if params[key].is_a?(Array) && !params[key].include?(value)

            return if params[key].is_a?(Array)

            raise InvalidParamError unless value.is_a?(ARG_MAP[params[key]])
          end
        end
      end
    end
  end
end
