require 'covenant/assertions/is_a'
require 'covenant/assertions/is'
require 'covenant/assertions/query'

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
      Covenant::Assertion.new(target, message)
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
      Covenant::Denial.new(target, message)
    end
  end

  class AssertionFailed < Exception; end

  class Statement
    include Assertions

    def initialize(target, message)
      @target = target
      @message   = message
    end

    protected

    attr_reader :target, :message

    def raise_error(message)
      msg = self.message || message

      if msg
        raise AssertionFailed, msg
      else
        raise AssertionFailed
      end
    end
  end

  class Assertion < Statement
    private

    def test(condition, message = nil, _ = nil)
      if condition
        target
      else
        raise_error message
      end
    end
  end

  class Denial < Statement
    private

    def test(condition, _ = nil, message = nil)
      if ! condition
        target
      else
        raise_error message
      end
    end
  end
end
