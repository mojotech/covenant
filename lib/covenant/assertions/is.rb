module Covenant
  module Assertions
    module Is
      def method_missing(name, *args)
        strip = name.to_s.sub(/^is_/, '')
        query = "#{strip}?"
        argl  = args.map(&:inspect).join(", ")

        if target.respond_to?(query)
          test target.send(query, *args),
               "#{target.inspect} must be #{strip} #{argl}",
               "#{target.inspect} must not be #{strip} #{argl}"
        else
          super
        end
      end

      Covenant::Assertions.send :include, self
    end
  end
end
