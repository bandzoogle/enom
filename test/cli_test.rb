require 'test_helper'
require File.expand_path('../lib/enom/cli', __dir__)

class CliTest < Minitest::Test
  def setup
    Enom::Client.username = 'resellid'
    Enom::Client.password = 'resellpw'
    Enom::Client.test = true
    @cli = Enom::CLI.new
  end

  def test_domain_is_available
    VCR.use_cassette(__method__) do
      assert_equal 'test123456test1234561111111111111111111.com is available', @cli.execute('check', ['test123456test1234561111111111111111111.com'])
    end
  end

  def test_domain_is_unavailable
    VCR.use_cassette(__method__) do
      assert_equal 'google.com is unavailable', @cli.execute('check', ['google.com'])
    end
  end

  def test_register_domain
    VCR.use_cassette(__method__) do
      assert_equal 'Registered test123456test123456xzzzzzzz.com', @cli.execute('register', ['test123456test123456xzzzzzzz.com'])
    end
  end

  def test_renew_domain
    VCR.use_cassette(__method__) do
      assert_equal 'Renewed test123456test123456xzzzzzzz.com', @cli.execute('renew', ['test123456test123456xzzzzzzz.com'])
    end
  end
end
