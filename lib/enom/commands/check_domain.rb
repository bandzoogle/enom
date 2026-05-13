module Enom
  module Commands
    class CheckDomain
      def execute(args, _options = {})
        name = args.shift
        response = Domain.check(name)
        "#{name} is #{response}"
      end
    end
  end
end
