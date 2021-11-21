
class Dan::Api::Resources::Client::PaypalAccount < ::Dan::Api::Resources::Base
  ATTRIBUTES = %i[id email].freeze
  attr_reader(*ATTRIBUTES)

  def update(params = {})
    client.authenticated do
      response = client.request(
        :put,
        "#{parent.url}/#{::Dan::Api::Resources::Client::PaypalAccounts::BASE_URL}/#{id}",
        params
      )
      assign(::Dan::Api::Resources::Client::PaypalAccount.new(client, JSON.parse(response.body)['paypal_account']))
    end
  end
end
