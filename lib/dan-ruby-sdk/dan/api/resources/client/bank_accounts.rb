
class Dan::Api::Resources::Client::BankAccounts
  include ::Dan::Api::Resources::List

  BASE_URL = 'bank_accounts'.freeze

  def all
    clear

    client.authenticated do
      response = client.request(:get, "#{parent.url}/#{BASE_URL}")
      JSON.parse(response.body)['bank_accounts'].each do |bank_account|
        self << ::Dan::Api::Resources::Client::BankAccount.new(
          client,
          bank_account.slice(*::Dan::Api::Resources::Client::BankAccount::ATTRIBUTES.map(&:to_s)),
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
        { bank_account: params }
      )
      ::Dan::Api::Resources::Client::BankAccount.new(client, JSON.parse(response.body)['bank_account'], parent)
    end
  end
end
