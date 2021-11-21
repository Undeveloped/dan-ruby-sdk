
class Dan::Api::Resources::Client::BankAccount < ::Dan::Api::Resources::Base
  ATTRIBUTES = %i[id region bank_name bank_code account_number routing_number address city zip account_holder].freeze
  attr_reader(*ATTRIBUTES)

  def update(params = {})
    client.authenticated do
      response = client.request(
        :put,
        "#{parent.url}/#{::Dan::Api::Resources::Client::BankAccounts::BASE_URL}/#{id}",
        params
      )
      assign(::Dan::Api::Resources::Client::BankAccount.new(client, JSON.parse(response.body)['bank_account']))
    end
  end
end
