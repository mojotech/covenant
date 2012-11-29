module Covenant
  module Assertions
    module Is
      def method_missing(name, *args)
        strip = name.to_s.sub(/^is_/, '')
        query = "#{strip}?"
        argl  = args.map(&:inspect).join(", ")

        if condition.respond_to?(query)
          test condition.send(query, *args),
               "#{condition.inspect} must be #{strip} #{argl}",
               "#{condition.inspect} must not be #{strip} #{argl}"
        else
          super
        end
      end

      Covenant::Assertions.send :include, self
    end
  end
end
