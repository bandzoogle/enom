module Enom
  module Commands
    class ListDomains
      def execute(_args, _options = {})
        domains = Domain.all
        puts "Found #{domains.length} domains:"
        domains.each do |domain|
          puts "\s\s#{domain.name}"
        end
      end
    end
  end
end
