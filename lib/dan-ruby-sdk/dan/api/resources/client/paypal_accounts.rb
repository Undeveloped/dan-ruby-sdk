
class Dan::Api::Resources::Client::PaypalAccounts
  include ::Dan::Api::Resources::List

  BASE_URL = 'paypal_accounts'.freeze

  def all
    clear

    client.authenticated do
      response = client.request(:get, "#{parent.url}/#{BASE_URL}")

      JSON.parse(response.body)['paypal_accounts'].each do |paypal_account|
        self << ::Dan::Api::Resources::Client::PaypalAccount.new(
          client,
          paypal_account.slice(*::Dan::Api::Resources::Client::PaypalAccount::ATTRIBUTES.map(&:to_s)),
          parent,
        )
      end
    end

    self
  end

  def create(params = {})
    client.authenticated do
      response = client.request(
        :post,
        "#{parent.url}/#{BASE_URL}",
        params
      )
      ::Dan::Api::Resources::Client::PaypalAccount.new(client, JSON.parse(response.body)['paypal_account'], parent)
    end
  end
end
