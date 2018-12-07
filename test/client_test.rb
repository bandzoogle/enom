require "test_helper"

describe Enom::Client do
  context "A test connection" do
    before do
      Enom::Client.username = "resellidtest"
      Enom::Client.password = "resellpwtest"
      Enom::Client.test = true
    end

    it "should return a test Enom::Client object" do
      assert_equal "resellidtest", Enom::Client.username
      assert_equal "resellpwtest", Enom::Client.password
      assert_equal "https://resellertest.enom.com/interface.asp", Enom::Client.base_uri
      assert_equal Hash["UID" => "resellidtest", "PW" => "resellpwtest", "ResponseType" => "xml"], Enom::Client.default_params
    end
  end

  context "A live connection" do
    before do
      Enom::Client.username = "resellid"
      Enom::Client.password = "resellpw"
      Enom::Client.test = false
    end

    it "should return a real Enom::Client object" do
      assert_equal "resellid", Enom::Client.username
      assert_equal "resellpw", Enom::Client.password
      assert_equal "https://reseller.enom.com/interface.asp", Enom::Client.base_uri
      assert_equal Hash["UID" => "resellid", "PW" => "resellpw", "ResponseType" => "xml"], Enom::Client.default_params
    end
  end

end
