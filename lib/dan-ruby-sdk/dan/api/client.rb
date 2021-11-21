require_relative 'resources/base'
require 'httparty'

module Dan
  module Api
    class Client
      class InvalidEnvironmentError < StandardError; end
      class UnauthentticatedError < StandardError; end
      class ForbiddenError < StandardError; end
      class BadRequestError < StandardError; end
      class InvalidError < StandardError; end

      HOST_MAP = {
        sandbox: 'https://sandbox.dan.com',
        production: 'https://dan.com',
        development: 'http://localhost:3000'
      }.freeze

      attr_reader :integrator_token, :jwt_token, :environment

      def initialize(params = {})
        @integrator_token = params[:integrator_token]
        @environment = params[:environment].to_sym || :production

        validate_attributes!
      end

      def authenticate!
        return jwt_token if jwt_token.present?

        response = request(
          :post,
          'tokens',
          {
            integrator_token: integrator_token
          }
        )

        @jwt_token = JSON.parse(response.body)['token']
      end

      def distribution_network
        @distribution_network ||= OpenStruct.new(
          listings: Resources::DistributionNetwork::Listings.new(self),
          domains: Resources::DistributionNetwork::Domains.new(self)
        )
      end

      def conversations
        @conversations ||= ::Dan::Api::Resources::Conversations.new(self)
      end

      def clients
        @clients ||= ::Dan::Api::Resources::Clients.new(self)
      end

      def orders
        @orders ||= ::Dan::Api::Resources::Orders.new(self)
      end

      def domains
        @domains ||= ::Dan::Api::Resources::Domains.new(self)
      end

      def authenticated
        authenticate!
        yield
      rescue UnauthentticatedError
        authenticate!
      end

      def headers
        {
          "Authorization": "Bearer #{jwt_token}",
          "Content-Type": 'application/json'
        }
      end

      def request(request_type, path, body = nil, absolute = false)
        uri = if absolute
                path
              else
                "#{host}/api/integrator/v1/#{path}"
              end

        response = ::HTTParty.send(request_type, uri, headers: headers, body: body.to_json)

        case response.code.to_i
        when 401
          raise UnauthentticatedError
        when 403
          raise ForbiddenError
        when 422
          raise InvalidError, response
        when 400
          raise BadRequestError
        end

        response
      end

      private

      def host
        @host ||= HOST_MAP[environment]
      end

      def validate_attributes!
        validate_environment!
      end

      def validate_environment!
        return true if %i[production sandbox development].include?(environment)

        raise InvalidEnvironmentError, 'Invalid environment, valid values are: production, sandbox, development'
      end
    end
  end
end
