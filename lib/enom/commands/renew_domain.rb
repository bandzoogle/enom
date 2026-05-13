module Enom
  module Commands
    class RenewDomain
      def execute(args, _options = {})
        name = args.shift
        domain = Domain.renew!(name)
        "Renewed #{domain.name}"
      end
    end
  end
end
