require 'sourcify'

module Covenant
  # Adds the Covenant DSL to base.
  #
  # @api public
  #
  # @param base where to add the Covenant DSL
  def self.abide(base = Object, as = [:assert, :asserting])
    target = Class === base ? base : base.singleton_class

    target.class_eval do
      include Covenant::DSL

      case as
      when Array
        as.each do |a|
          alias_method a, :_assert
        end
      when Symbol, String
        alias_method as, :_assert
      else
        raise ArgumentError, "cannot register `#{as.inspect}` as method names"
      end
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
    def _assert(&block)
      raise ArgumentError, "no block given" unless block_given?

      tap { yield self or raise AssertionFailed, ErrorMessage.new(block) }
    end
  end

  class AssertionFailed < StandardError; end

  class ErrorMessage
    def initialize(block)
      @block = block
    end

    def to_s
      "block did not return true:\n\n#{source_block}\n\n#{variable_block}"
    end

    private

    attr_reader :block

    def indent(str)
      "  " + str.gsub(/\n/, "\n  ").strip
    end

    def source
      block.to_source
    end

    def source_block
      "Source:\n\n#{indent(source)}"
    end

    def variable_block
      b = variables.
       inject("") { |a, (var, val)|
        a << "#{var} = #{val.inspect}\n"
      }

      "Variables:\n\n" + indent(b)
    end

    def variables
      s  = source
      b  = block.binding
      lv = b.eval('local_variables')

      lv.
       select { |v| s =~ /\b#{v}\b/ }.
       map    { |v| [v, b.eval(v.to_s)] }
    end
  end
end
