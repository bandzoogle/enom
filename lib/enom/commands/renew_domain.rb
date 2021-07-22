module Enom
  module Commands
    class RenewDomain
      def execute(args, options={})
        name = args.shift
        domain = Domain.renew!(name)
        output = "Renewed #{domain.name}"
        return output
      end
    end
  end
end
