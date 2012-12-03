module Covenant
  module Assertions
    module Query
      def method_missing(name, *args)
        query    = "#{name}?"
        argl     = args.map(&:inspect).join(", ")

        if target.respond_to?(query)
          return test(target.send(query, *args),
                      "#{target.inspect} must #{name} #{argl}",
                      "#{target.inspect} must not #{name} #{argl}")
        end

        no_is    = name.to_s.sub(/^is_/, '')
        is_query = "#{no_is}?"

        if target.respond_to?(is_query)
          return test(target.send(is_query, *args),
                      "#{target.inspect} must be #{no_is} #{argl}",
                      "#{target.inspect} must not be #{no_is} #{argl}")
        end

        super
      end

      Covenant::Assertions.send :include, self
    end
  end
end
