module Dan
  module Api
    module Resources
      module Sandbox
        class Action
          attr_reader :client, :resource, :action, :params, :http_method

          def initialize(client, resource, action, http_method, params = {})
            @client = client
            @resource = resource
            @action = action
            @params = params
            @http_method = http_method
          end


          def call
            raise ::Dan::Api::InvalidEnvironmentError unless client.environment == :sandbox

            client.authenticated do
              client.request(http_method, "#{resource.url}/#{action}", params)

              resource.get
            end
          end
        end
      end
    end
  end
end
