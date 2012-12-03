module Covenant
  module Assertions
    module IsA
      def is_a(type)
        type.is_a?(Class) or
         ::Kernel.raise ArgumentError, "#{type.inspect} must be a Class"

        test target.is_a?(type),
             "#{target.inspect} must be a #{type.name}",
             "#{target.inspect} must not be a #{type.name}"
      end

      alias_method :is_an, :is_a

      Covenant::Assertions.send :include, self
    end
  end
end
