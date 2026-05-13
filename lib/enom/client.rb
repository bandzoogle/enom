module Enom
  require 'net/http'
  require 'multi_xml'

  class Client
    class << self
      attr_accessor :username, :password, :test, :debug
      alias test? test
      alias debug? debug

      # All requests must contain the UID, PW, and ResponseType query parameters
      def default_params
        { 'UID' => username, 'PW' => password, 'ResponseType' => 'xml' }
      end

      # Enom has a test platform and a production platform.  Both are configured to use
      # HTTPS at all times. Don"t forget to configure permitted IPs (in both environments)
      # or you"ll get InterfaceErrors.
      def base_uri
        @base_uri = test? ? 'https://resellertest.enom.com/interface.asp' : 'https://reseller.enom.com/interface.asp'
      end

      # All requests to Enom are GET requests, even when we"re changing data.  Unfortunately,
      # Enom also does not provide HTTP status codes to alert for authentication failures
      # or other helpful statuses -- everything comes back as a 200.
      def request(params = {})
        params.merge!(default_params)

        uri = URI.parse(base_uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        encoded = URI.encode_www_form(params)
        path = [uri.path, encoded].join('?')

        request = Net::HTTP::Get.new(path)

        warn path if debug?

        response = http.request(request)

        case response.code.to_i
        when 200
          warn response.body if debug?

          response = MultiXml.parse(response.body)
          return response if response['interface_response']['ErrCount'].to_i == 0

          raise InterfaceError, response['interface_response']['errors'].values.join(', ')

        end
      end

      def get(params = {})
        request(params)
      end
    end
  end
end
