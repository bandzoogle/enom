require 'rubygems'
require 'shoulda'
require 'minitest/autorun'
require 'minitest-spec-context'
require 'vcr'

require File.expand_path('../lib/enom', __dir__)

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = {
    record: :once
  }
end
