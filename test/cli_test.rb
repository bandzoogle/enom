require "test_helper"
require File.expand_path("../../lib/enom/cli",   __FILE__)

class CliTest < Minitest::Test
  def setup
    Enom::Client.username = "resellid"
    Enom::Client.password = "resellpw"
    Enom::Client.test = false
    @cli = Enom::CLI.new
  end

  def test_domain_is_available
    assert_equal "test123456test123456.com is available", @cli.execute("check", ["test123456test123456.com"])
  end

  def test_domain_is_unavailable
    assert_equal "google.com is unavailable", @cli.execute("check", ["google.com"])
  end

  def test_register_domain
    assert_equal "Registered test123456test123456.com", @cli.execute("register", ["test123456test123456.com"])
  end

  def test_renew_domain
    assert_equal "Renewed test123456test123456.com", @cli.execute("renew", ["test123456test123456.com"])
  end
end
