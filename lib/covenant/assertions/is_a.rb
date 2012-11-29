module Covenant
  module Assertions
    module IsA
      def is_a(type)
        type.is_a?(Class) or
         raise ArgumentError, "#{type.inspect} must be a Class"

        test condition.is_a?(type),
             "#{condition.inspect} must be a #{type.name}",
             "#{condition.inspect} must not be a #{type.name}"
      end

      alias_method :is_an, :is_a

      Covenant::Assertions.send :include, self
    end
  end
end
