require 'test_helper'

describe Enom::Domain do
  describe 'With a valid account' do
    before do
      Enom::Client.username = 'resellid'
      Enom::Client.password = 'resellpw'
      Enom::Client.test = true
    end

    describe'listing all domains' do
      before do
        Enom::Client.test = true
      end

      it 'should return several domain objects' do
        VCR.use_cassette(__method__) do
          @domains = Enom::Domain.all('limit' => 25, 'Display' => 10)
          @domains.each do |domain|
            assert_kind_of Enom::Domain, domain
          end
        end
      end

      it 'should return a bunch of domains' do
        VCR.use_cassette(__method__) do
          @domains = Enom::Domain.all('limit' => 25, 'Display' => 10)
          assert_equal 30, @domains.size
        end
      end

      it 'accepts a block' do
        VCR.use_cassette(__method__) do
          @count = 0
          @domain = nil

          @domains = Enom::Domain.all('limit' => 25, 'Display' => 10) do |result|
            @domain = result
            @count = @count + 1
          end
          assert_equal 30, @count
          assert_kind_of Enom::Domain, @domain
        end

      end
    end

    describe'available?' do
      it "should return 'available' for an available domain" do
        VCR.use_cassette(__method__) do
          assert_equal 'available', Enom::Domain.check('test123456test123456xyzzy.com')
          assert Enom::Domain.available?('test123456test123456xyzzy.com')
        end
      end
      it "should return 'unavailable' for an unavailable domain" do
        VCR.use_cassette(__method__) do
          assert_equal 'unavailable', Enom::Domain.check('google.com')
          assert !Enom::Domain.available?('google.com')
        end
      end
    end

    describe'check_details' do
      it 'should return data for available domain' do
        VCR.use_cassette(__method__) do
          result = Enom::Domain.check_details('test123456test123456xyzzy.com')
          assert_equal true, result['available']
          assert_equal false, result['IsPremium']
        end
      end
      it "should return 'unavailable' for an unavailable domain" do
        VCR.use_cassette(__method__) do
          result = Enom::Domain.check_details('google.com')
          assert_equal false, result['available']
          assert_equal false, result['IsPremium']
        end
      end
      it 'should return premium data for premium domain' do
        VCR.use_cassette(__method__) do
          result = Enom::Domain.check_details('foobarfoobarfoobar.adult')
          assert_equal true, result['available']
          assert_equal true, result['IsPremium']
        end
      end
    end

    describe'checking multiple TLDs for a single domain' do
      it 'should return an array of available domains with the provided TLD' do
        wildcard_tld_domains = ['test123456test123456.biz', 'test123456test123456.info', 'test123456test123456.net',
                                'test123456test123456.org']
        VCR.use_cassette(__method__) do
          result = Enom::Domain.check_multiple_tlds('test123456test123456', '*').sort
          assert_equal wildcard_tld_domains.sort, result
        end
      end
    end

    describe'checking for suggested domains' do
      it 'should return an array of suggestions matching the supplied term' do
        VCR.use_cassette(__method__) do
          @suggestions = Enom::Domain.suggest('hand.com')
          assert !@suggestions.empty?

          results = ['shophand.net', 'myfist.net', 'fistinc.net', 'handdesign.net', 'freefist.net', 'holdinc.net',
                     'holdgroup.net', 'handcompany.net']

          assert_equal results, @suggestions
        end
      end

      it 'should only return the results matching specified tlds' do
        VCR.use_cassette(__method__) do
          @suggestions = Enom::Domain.suggest('hand.com', tlds: %w[com net])
          assert !@suggestions.empty?

          results = ["shophand.net", "myfist.net", "fistinc.net", "handdesign.net", "freefist.net", "holdinc.net", "holdgroup.net", "handcompany.net"]

          assert_equal results, @suggestions
        end
      end
    end

    describe'registering a domain' do
      it 'should register the domain and return a domain object' do
        VCR.use_cassette(__method__) do
          @domain = Enom::Domain.register!('aaatest123456test123456789xxxxyyyyzzzz.com')
          assert_kind_of Enom::Domain, @domain
          assert_equal @domain.name, 'aaatest123456test123456789xxxxyyyyzzzz.com'
        end
      end
    end

    describe'registering a .rocks domain' do
      # before do
      #   @domain = Enom::Domain.register!("test123456test123456789.rocks")
      # end
      # it "should register the domain and return a domain object" do
      #   VCR.use_cassette(__method__) do
      #     assert_kind_of Enom::Domain, @domain
      #     assert_equal @domain.name, "test123456test123456789.rocks"
      #   end
      # end
    end

    describe'registering a domain with some options' do
      it 'should pass opts along' do
        VCR.use_cassette(__method__) do
          @domain = Enom::Domain.register!('elephanttest123456test123456789abc.com',
                                           'RegistrantFirstName' => 'Test',
                                           'RegistrantLastName' => 'Tester',
                                           RegistrantAddress1: '22 Test Lane',
                                           RegistrantAddress2: '',
                                           RegistrantCity: 'Chicago',
                                           RegistrantStateProvinceChoice: 'S',
                                           RegistrantStateProvince: 'Illinois',
                                           RegistrantPostalCode: '60608',
                                           RegistrantCountry: 'US',
                                           RegistrantEmailAddress: 'foo@bar.com')

          assert_kind_of Enom::Domain, @domain
          assert_equal @domain.name, 'elephanttest123456test123456789abc.com'
        end
      end
    end

    describe'deleting a domain' do
      before do
        @result = Enom::Domain.delete!('resellerdocs3.com')
      end

      # it "should delete the domain and return true" do
      #   VCR.use_cassette(__method__) do
      #     assert @result
      #   end
      # end
    end

    describe'sync_auth_info for domain' do
      it 'should return the domain' do
        VCR.use_cassette(__method__) do
          @domain = Enom::Domain.find('17feb2020.com')
          @result = @domain.sync_auth_info
          assert @result
        end
      end
    end

    describe'transfer a domain' do
      it 'should transfer the domain and return true if successful' do
        VCR.use_cassette(__method__) do
          @result = Enom::Domain.transfer!('resellerdocs2.net', 'ros8enQi')
          assert @result
        end
      end
    end

    describe'renewing a domain' do
      it 'should renew the domain and return a domain object' do
        VCR.use_cassette(__method__) do
          @domain = Enom::Domain.renew!('test123456test123456789abc.com')
          assert_kind_of Enom::Domain, @domain
          assert_equal @domain.name, 'test123456test123456789abc.com'
        end
      end
    end

    describe'finding a domain in your account' do
      it 'should return a domain object' do
        VCR.use_cassette(__method__) do
          @domain = Enom::Domain.find('test123456test123456789.com')
          assert_kind_of Enom::Domain, @domain
        end
      end

      it 'should have corect attributes' do
        VCR.use_cassette(__method__) do
          @domain = Enom::Domain.find('test123456test123456789.com')

          assert_equal 'test123456test123456789.com', @domain.name
          assert_equal 'test123456test123456789', @domain.sld
          assert_equal 'com', @domain.tld
        end
      end

      it 'should be registered' do
        VCR.use_cassette(__method__) do
          @domain = Enom::Domain.find('test123456test123456789.com')

          assert @domain.active?
          assert !@domain.expired?
        end
      end

      it 'should be locked' do
        VCR.use_cassette(__method__) do
          @domain = Enom::Domain.find('test123456test123456789.com')
          @domain.lock rescue nil

          assert @domain.locked?
          assert !@domain.unlocked?
        end
      end

      describe'with default nameservers' do
        it 'should have default Enom nameservers' do
          VCR.use_cassette(__method__) do
            nameservers = [
              'dns1.name-services.com',
              'dns2.name-services.com',
              'dns3.name-services.com',
              'dns4.name-services.com',
              'dns5.name-services.com'
            ]

            @domain = Enom::Domain.find('test123456test123456789.com')
            assert_equal nameservers, @domain.nameservers
          end
        end
        it 'should update nameservers if there are 2 or more provided' do
          VCR.use_cassette(__method__) do
            new_nameservers = ['dns1.name-services.com',
            'dns2.name-services.com']

            @domain = Enom::Domain.find('test123456test123456789.com')
            @domain.update_nameservers(new_nameservers)
            assert_equal new_nameservers, @domain.nameservers.sort
          end
        end
        it 'should not update nameservers if less than 2 or more than 12 are provided' do
          VCR.use_cassette(__method__) do
            not_enough = ['ns1.foo.com']
            too_many = ['ns1.foo.com', 'ns2.foo.com', 'ns3.foo.com', 'ns4.foo.com', 'ns5.foo.com', 'ns6.foo.com',
                        'ns7.foo.com', 'ns8.foo.com', 'ns9.foo.com', 'ns10.foo.com', 'ns11.foo.com', 'ns12.foo.com', 'ns13.foo.com']

            @domain = Enom::Domain.find('test123456test123456789.com')

            assert_raises Enom::InvalidNameServerCount do
              @domain.update_nameservers(not_enough)
            end
            assert_raises Enom::InvalidNameServerCount do
              @domain.update_nameservers(too_many)
            end
          end
        end
      end

      it 'should have an expiration date' do
        VCR.use_cassette(__method__) do
          @domain = Enom::Domain.find('test123456test123456789.com')

          assert_kind_of Date, @domain.expiration_date
          assert_equal '2023-08-25', @domain.expiration_date.strftime('%Y-%m-%d')
        end
      end

      describe'that is currently locked' do
        it 'should unlock successfully' do
          VCR.use_cassette(__method__) do
            @domain = Enom::Domain.find('test123456test123456789.com')

            @domain.unlock

            assert !@domain.locked?
            assert @domain.unlocked?
          end
        end
      end
    end
  end
end
