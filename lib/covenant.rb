module Covenant
  # Adds the Covenant DSL to base.
  #
  # @api public
  #
  # @param base where to add the Covenant DSL
  def self.abide(base = Object)
    case base
    when Class
      base.send :include, Covenant::DSL
    else
      base.extend Covenant::DSL
    end
  end

  module DSL
    # Ensures that the condition on target evaluates to a true value.
    #
    # @api public
    #
    # @param target the target on which to test the condition
    # @param [#to_s] message the message that will be set if the test fails
    #
    # @return the wrapper object you can use to test your assertions
    def assert(target = self, message = nil)
      if block_given?
        Covenant::Assertion.new(target, message).test(yield target)
      else
        Covenant::Assertion.new(target, message)
      end
    end

    # Ensures that the condition on target evaluates to a false value.
    #
    # @api public
    #
    # @param target the target on which to test the condition
    # @param message the message that will be set if the test fails
    #
    # @return the wrapper object you can use to test your assertions
    def deny(target = self, message = nil)
      if block_given?
        Covenant::Denial.new(target, message).test(yield target)
      else
        Covenant::Denial.new(target, message)
      end
    end
  end

  class AssertionFailed < Exception; end

  class Statement < BasicObject
    def initialize(target, message)
      @target = target
      @message   = message
    end

    def ==(other)
      test(target == other,
           "#{target.inspect} must == #{other.inspect}",
           "#{target.inspect} must != #{other.inspect}")
    end

    def !=(other)
      test(target != other,
           "#{target.inspect} must != #{other.inspect}",
           "#{target.inspect} must == #{other.inspect}")
    end

    def method_missing(name, *args)
      argl = args.map(&:inspect).join(", ")

      if target.respond_to?(name)
        return test(target.send(name, *args),
                    "#{target.inspect} must #{name} #{argl}",
                    "#{target.inspect} must not #{name} #{argl}")
      end

      query = "#{name}?"

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

    protected

    attr_reader :target, :message

    def raise_error(message)
      msg = self.message || message

      if msg
        ::Kernel.raise AssertionFailed, msg
      else
        ::Kernel.raise AssertionFailed
      end
    end
  end

  class Assertion < Statement
    def test(condition, message = nil, _ = nil)
      if condition
        target
      else
        raise_error message
      end
    end
  end

  class Denial < Statement
    def test(condition, _ = nil, message = nil)
      if ! condition
        target
      else
        raise_error message
      end
    end
  end
end
