require 'spec_helper'

describe Covenant do
  describe Covenant::DSL do
    Covenant.abide self

    describe "#assert" do
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

  describe Covenant::ErrorMessage do
    subject(:message) {
      a = 1
      b = 2
      c = "invisible"

      Covenant::ErrorMessage.new(->{ a + b && "literal" }).to_s
    }

    it "shows the block's source" do
      expect(message).to match(/proc \{.+\}/)
    end

    it "shows relevant variable values" do
      expect(message).to match(/a = 1/)
      expect(message).to match(/b = 2/)
      expect(message).not_to match(/c = "invisible"/)
    end
  end
end
