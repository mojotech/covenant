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

    describe "#deny" do
      context "with block" do
        it "passes if the block expression evaluates to false" do
          expect { deny { false } }.not_to raise_error
        end

        it "fails if the block expression evaluates to true" do
          expect { deny { true } }.to raise_error(Covenant::AssertionFailed)
        end

        it "yields the receiver" do
          Covenant.abide s = "hi"

          s.deny { |r| expect(r).to eq "hi"; false }
        end

        it "returns the receiver" do
          expect(deny { false }).to be self
        end
      end
    end
  end

  describe Covenant::Statement do
    include Covenant::DSL

    describe 'assertion' do
      subject(:assertion) { assert('hi') }

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

      it "fails if the receiver answers == with a false value" do
        expect { assertion == 'yo' }.
         to raise_error(Covenant::AssertionFailed, /must == "yo"/)
      end

      it "fails if the receiver answers != with a false value" do
        expect { assertion != 'hi' }.
         to raise_error(Covenant::AssertionFailed, /must != "hi"/)
      end

      it "fails if the receiver answers the query with a false value" do
        expect { assertion.end_with('a') }.
         to raise_error(Covenant::AssertionFailed, /must end_with "a"/)
      end

      it "fails if the receiver answers the 'is' query with a false value" do
        expect { assertion.is_empty }.
         to raise_error(Covenant::AssertionFailed, /must be empty/)
      end
    end

    describe 'denial' do
      subject(:denial) { deny('hi') }

      it "passes if the answers == with a false value" do
        expect { denial == 'yo' }.
         not_to raise_error(Covenant::AssertionFailed)
      end

      it "passes if the answers the query with a false value" do
        expect { denial.start_with('o') }.
         not_to raise_error(Covenant::AssertionFailed)
      end

      it "passes if the answers the 'is' query with a false value" do
        expect { denial.is_empty }.
         not_to raise_error(Covenant::AssertionFailed)
      end

      it "fails if the receiver answers == with a true value" do
        expect { denial == 'hi' }.
         to raise_error(Covenant::AssertionFailed, /must != "hi"/)
      end

      it "fails if the receiver answers the query with a true value" do
        expect { denial.end_with('i') }.
         to raise_error(Covenant::AssertionFailed, /must not end_with "i"/)
      end

      it "fails if the receiver answers the 'is' query with a true value" do
        expect { denial.is_ascii_only }.
         to raise_error(Covenant::AssertionFailed, /must not be ascii_only/)
      end
    end
  end
end
