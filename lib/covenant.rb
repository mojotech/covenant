require 'covenant/assertions/is_a'
require 'covenant/assertions/is'

module Covenant
  # Adds the Covenant DSL to base.
  #
  # @api public
  #
  # @param base where to add the Covenant DSL
  def self.abide(base = Object)
    base.send :include, Covenant::DSL
  end

  module DSL
    # Ensures that condition evaluates to a true value.
    #
    # @api public
    #
    # @param condition the condition to test
    # @param [#to_s] message the message that will be set if the test fails
    #
    # @return the wrapper object you can use to test your assertions
    def assert(condition, message = nil)
      Covenant::Assertion.new(condition, message)
    end

    # Ensures that condition evaluates to a false value.
    #
    # @api public
    #
    # @param condition the condition to test
    # @param message the message that will be set if the test fails
    #
    # @return the wrapper object you can use to test your assertions
    def deny(condition, message = nil)
      Covenant::Denial.new(condition, message)
    end
  end

  class AssertionFailed < Exception; end

  class Statement
    include Assertions

    def initialize(condition, message)
      @condition = condition
      @message   = message
    end

    protected

    attr_reader :condition, :message

    def raise_error(message)
      raise AssertionFailed, self.message || message
    end
  end

  class Assertion < Statement
    private

    def test(condition, message, _)
      condition or raise_error(message)
    end
  end

  class Denial < Statement
    private

    def test(condition, _, message)
      ! condition or raise_error(message)
    end
  end
end
