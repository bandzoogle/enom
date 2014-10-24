require "test_helper"

class AccountTest < MiniTest::Unit::TestCase

  context "An authorized account" do
    setup do
      Enom::Client.username = "resellid"
      Enom::Client.password = "resellpw"
      Enom::Client.test = false
    end

    should "return the available account balance" do
      assert_equal 3669.40, Enom::Account.balance
    end
  end
end
