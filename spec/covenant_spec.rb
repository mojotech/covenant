require 'spec_helper'

describe Covenant do
  describe Covenant::DSL do
    include Covenant::DSL

    describe "#assert" do
      context "with block" do
        it "passes if the block expression evaluates to true" do
          expect { assert { true } }.not_to raise_error
        end

        it "fails if the block expression evaluates to false" do
          expect { assert { false } }.to raise_error(Covenant::AssertionFailed)
        end

        it "yields the receiver" do
          Covenant.abide s = "hi"

          expect { s.assert { |r| r == "hi" } }.not_to raise_error
        end

        it "returns the receiver" do
          expect(assert { true }).to be self
        end
      end
    end
  end

  describe Covenant::Statement do
    include Covenant::DSL

    describe 'assertion' do
      subject(:assertion) { assert('hi') }

      it "passes if the receiver answers the bare query with a true value" do
        expect { assertion =~ /hi/ }.not_to raise_error
      end

      it "passes if the receiver answers == with a true value" do
        expect { assertion == 'hi' }.not_to raise_error
      end

      it "passes if the receiver answers != with a true value" do
        expect { assertion != 'yo' }.not_to raise_error
      end

      it "passes if the receiver answers the query with a true value" do
        expect { assertion.start_with('h') }.not_to raise_error
      end

      it "passes if the receiver answers the 'is' query with a true value" do
        expect { assertion.is_ascii_only }.not_to raise_error
      end

      it "fails if the receiver answers the bare query with a false value" do
        expect { assertion =~ /yo/ }.to raise_error(Covenant::AssertionFailed)
      end

      it "fails if the receiver answers == with a false value" do
        expect { assertion == 'yo' }.to raise_error(Covenant::AssertionFailed)
      end

      it "fails if the receiver answers != with a false value" do
        expect { assertion != 'hi' }.to raise_error(Covenant::AssertionFailed)
      end

      it "fails if the receiver answers the query with a false value" do
        expect { assertion.end_with('a') }.
         to raise_error(Covenant::AssertionFailed)
      end

      it "fails if the receiver answers the 'is' query with a false value" do
        expect { assertion.is_empty }.to raise_error(Covenant::AssertionFailed)
      end
    end
  end
end
