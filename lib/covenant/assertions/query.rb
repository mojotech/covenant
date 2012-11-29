module Covenant
  module Assertions
    module Query
      def method_missing(name, *args)
        query = "#{name}?"
        argl  = args.map(&:inspect).join(", ")

        if target.respond_to?(query)
          test target.send(query, *args),
               "#{target.inspect} must #{name} #{argl}",
               "#{target.inspect} must not #{name} #{argl}"
        else
          super
        end
      end

      Covenant::Assertions.send :include, self
    end
  end
end
