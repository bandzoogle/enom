module Enom
  class Account
    def self.balance
      Client.request('Command' => 'GetBalance')['interface_response']['AvailableBalance'].delete(',').to_f
    end
  end
end
