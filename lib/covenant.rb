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

    alias_method :asserting, :assert
  end

  class AssertionFailed < Exception; end

  class Statement < BasicObject
    def initialize(target, message)
      @target  = target
      @message = message
    end

    def ==(other)
      test(target == other, ErrorMessage.new(target, :==, [other]))
    end

    def !=(other)
      test(target != other, ErrorMessage.new(target, :!=, [other]))
    end

    def method_missing(name, *args)
      if target.respond_to?(name)
        return test(target.send(name, *args),
                    ErrorMessage.new(target, name, args))
      end

      query = "#{name}?"

      if target.respond_to?(query)
        return test(target.send(query, *args),
                    ErrorMessage.new(target, query, args))
      end

      no_is    = name.to_s.sub(/^is_/, '')
      is_query = "#{no_is}?"

      if target.respond_to?(is_query)
        return test(target.send(is_query, *args),
                    ErrorMessage.new(target, is_query, args))
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

    class NullErrorMessage
      def for_assertion; end
      def for_denial; end
    end

    class ErrorMessage
      attr_reader :target, :message, :args

      def initialize(target, message, args)
        @target  = target
        @message = message
        @args    = args
      end

      def for_assertion
        error_message('should be true')
      end

      def for_denial
        error_message('should be false')
      end

      private

      def error_message(expected)
        argl = args.map(&:inspect).join(", ")

        "#{target.inspect}.#{message} #{argl} #{expected}"
      end
    end
  end

  class Assertion < Statement
    def test(condition, error_message = NullErrorMessage.new)
      if condition
        target
      else
        raise_error error_message.for_assertion
      end
    end
  end
end

=begin

require 'benchmark'

Covenant.abide self

Benchmark.bm do |x|
  x.report { 1_000_000.times { assert('aaa').start_with 'a' } }
  x.report { 1_000_000.times { 'aaa'.start_with? 'a' } }
end

=end
