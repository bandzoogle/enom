module Enom
  module Commands
    class CheckDomain
      def execute(args, options={})
        name = args.shift
        response = Domain.check(name)
        output = "#{name} is #{response}"
        return output
      end
    end
  end
end
