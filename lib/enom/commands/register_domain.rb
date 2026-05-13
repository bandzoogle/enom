module Enom
  module Commands
    class RegisterDomain
      def execute(args, _options = {})
        name = args.shift
        domain = Domain.register!(name)
        "Registered #{domain.name}"
      end
    end
  end
end
