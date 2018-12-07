require "test_helper"

#class DomainTest < Minitest::Test
describe Enom::Domain do
  context "With a valid account" do
    before do
      Enom::Client.username = "resellid"
      Enom::Client.password = "resellpw"
      Enom::Client.test = false
    end

    context "listing all domains" do
      before do
        @domains = Enom::Domain.all
      end
      it "should return several domain objects" do
        @domains.each do |domain|
          assert_kind_of Enom::Domain, domain
        end
      end
      it "should return two domains" do
        assert_equal 2, @domains.size
      end
    end

    context "checking for available domains" do
      it "should return 'available' for an available domain" do
        assert_equal "available", Enom::Domain.check("test123456test123456.com")
        assert Enom::Domain.available?("test123456test123456.com")
      end
      it "should return 'unavailable' for an unavailable domain" do
        assert_equal "unavailable", Enom::Domain.check("google.com")
        assert !Enom::Domain.available?("google.com")
      end
    end

    context "checking multiple TLDs for a single domain" do
      it "should return an array of available domains with the provided TLD" do
        wildcard_tld_domains = %w(
          test123456test123456.com
          test123456test123456.net
          test123456test123456.org
          test123456test123456.info
          test123456test123456.biz
          test123456test123456.ws
          test123456test123456.us
          test123456test123456.cc
          test123456test123456.tv
          test123456test123456.bz
          test123456test123456.nu
          test123456test123456.mobi
          test123456test123456.eu
          test123456test123456.ca
        )
        assert_equal wildcard_tld_domains.sort, Enom::Domain.check_multiple_tlds("test123456test123456","*").sort
        #assert_equal ["test123456test123456.us", "test123456test123456.ca", "test123456test123456.com"], Enom::Domain.check_multiple_tlds("test123456test123456", ["us", "ca", "com"])
      end
    end

    context "checking for suggested domains" do
      before do

      end
      it "should return an array of suggestions matching the supplied term" do
        @suggestions = Enom::Domain.suggest("hand.com")
        assert !@suggestions.empty?

        results = %w(
          handsewncurtains.net
          handsewncurtains.tv
          handsewncurtains.cc
          handicappingclub.net
          handicappingclub.tv
          handicappingclub.cc
          handingok.com
          handingok.net
          handingok.tv
          handingok.cc
          handsofjustice.tv
          handsofjustice.cc
          handoki.net
          handoki.tv
          handoki.cc
          handinghand.com
          handinghand.net
          handinghand.tv
          handinghand.cc
          handcrafthouselogs.com
          handcrafthouselogs.net
          handcrafthouselogs.tv
          handcrafthouselogs.cc
          handloser.tv
          handloser.cc
        )

        assert_equal results, @suggestions
      end

      it "should only return the results matching specified tlds" do
        @suggestions = Enom::Domain.suggest("hand.com", :tlds => %w(com net))
        assert !@suggestions.empty?

        results = %w(
          handsewncurtains.net
          handicappingclub.net
          handingok.com
          handingok.net
          handoki.net
          handinghand.com
          handinghand.net
          handcrafthouselogs.com
          handcrafthouselogs.net
        )

        assert_equal results, @suggestions
      end
    end

    context "registering a domain" do
      before do
        @domain = Enom::Domain.register!("test123456test123456.com")
      end
      it "should register the domain and return a domain object" do
        assert_kind_of Enom::Domain, @domain
        assert_equal @domain.name, "test123456test123456.com"
      end
    end

    context "registering a .rocks domain" do
      before do
        @domain = Enom::Domain.register!("test123456test123456.rocks")
      end
      it "should register the domain and return a domain object" do
        assert_kind_of Enom::Domain, @domain
        assert_equal @domain.name, "test123456test123456.rocks"
      end
    end

    context "registering a domain with some options" do
      before do
        @domain = Enom::Domain.register!("test123456test123456.com", "RegistrantFirstName" => "Test", "RegistrantLastName" => "Tester" )
      end
      it "should pass opts along" do
        assert_kind_of Enom::Domain, @domain
        assert_equal @domain.name, "test123456test123456.com"
      end
    end

    context "deleting a domain" do
      before do
        @result = Enom::Domain.delete!("resellerdocs3.com")
      end

      it "should delete the domain and return true" do
        assert @result
      end
    end

    context "sync_auth_info for domain" do
      before do
        @domain = Enom::Domain.find("test123456test123456.com")
        @result = @domain.sync_auth_info(
                                         )
      end

      it "should return the domain" do
        assert @result
      end
    end

    context "transfer a domain" do
      before do
        @result = Enom::Domain.transfer!("resellerdocs2.net", "ros8enQi")
      end
      it "should transfer the domain and return true if successful" do
        assert @result
      end
    end

    context "renewing a domain" do
      before do
        @domain = Enom::Domain.renew!("test123456test123456.com")
      end
      it "should renew the domain and return a domain object" do
        assert_kind_of Enom::Domain, @domain
        assert_equal @domain.name, "test123456test123456.com"
      end
    end

    context "finding a domain in your account" do
      before do
        @domain = Enom::Domain.find("test123456test123456.com")
      end

      it "should return a domain object" do
        assert_kind_of Enom::Domain, @domain
      end

      it "should have corect attributes" do
        assert_equal "test123456test123456.com", @domain.name
        assert_equal "test123456test123456", @domain.sld
        assert_equal "com", @domain.tld
      end

      it "should be registered" do
        assert @domain.active?
        assert !@domain.expired?
      end

      it "should be locked" do
        assert @domain.locked?
        assert !@domain.unlocked?
      end

      context "with default nameservers" do
        it "should have default Enom nameservers" do
          nameservers = [
            "dns1.name-services.com",
            "dns2.name-services.com",
            "dns3.name-services.com",
            "dns4.name-services.com",
            "dns5.name-services.com"
          ]
          assert_equal nameservers, @domain.nameservers
        end
        it "should update nameservers if there are 2 or more provided" do
          new_nameservers = ["ns1.foo.com", "ns2.foo.com"]
          @domain.update_nameservers(new_nameservers)
          assert_equal new_nameservers, @domain.nameservers.sort
        end
        it "should not update nameservers if less than 2 or more than 12 are provided" do
          not_enough = ["ns1.foo.com"]
          too_many = ["ns1.foo.com", "ns2.foo.com", "ns3.foo.com", "ns4.foo.com", "ns5.foo.com", "ns6.foo.com", "ns7.foo.com", "ns8.foo.com", "ns9.foo.com", "ns10.foo.com", "ns11.foo.com", "ns12.foo.com", "ns13.foo.com"]
          assert_raises Enom::InvalidNameServerCount do
            @domain.update_nameservers(not_enough)
          end
          assert_raises Enom::InvalidNameServerCount do
            @domain.update_nameservers(too_many)
          end
        end
      end

      it "should have an expiration date" do
        assert_kind_of Date, @domain.expiration_date
        assert_equal "2012-01-30", @domain.expiration_date.strftime("%Y-%m-%d")
      end

      context "that is currently locked" do
        before do
          @domain.unlock
        end

        it "should unlock successfully" do
          assert !@domain.locked?
          assert @domain.unlocked?
        end
      end
    end
  end

end
