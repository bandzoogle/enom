require "test_helper"

class TestAccount < Minitest::Test
  def setup
    Enom::Client.username = "resellid"
    Enom::Client.password = "resellpw"
    Enom::Client.test = false
  end

  def test_should_return_account_balance
    assert_equal 3669.40, Enom::Account.balance
  end
end
