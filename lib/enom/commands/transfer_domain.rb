module Enom
  module Commands
    class TransferDomain
      def execute(args, _options = {})
        name      = args.shift
        auth_code = args.shift
        Domain.transfer!(name, auth_code)
        output = "Transferred #{name}"
        puts output
        output
      end
    end
  end
end
