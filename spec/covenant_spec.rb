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
end
