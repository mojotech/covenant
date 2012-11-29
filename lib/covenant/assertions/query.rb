module Covenant
  module Assertions
    module Query
      def method_missing(name, *args)
        query = "#{name}?"
        argl  = args.map(&:inspect).join(", ")

        if condition.respond_to?(query)
          test condition.send(query, *args),
               "#{condition.inspect} must #{name} #{argl}",
               "#{condition.inspect} must not #{name} #{argl}"
        else
          super
        end
      end

      Covenant::Assertions.send :include, self
    end
  end
end
