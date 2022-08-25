require 'test_helper'

class TestAccount < Minitest::Test
  def setup
    Enom::Client.username = 'resellid'
    Enom::Client.password = 'resellpw'
    Enom::Client.test = true
  end

  def test_should_return_account_balance
    VCR.use_cassette(__method__) do
      assert_equal 9_982_840.5, Enom::Account.balance
    end
  end
end
