require 'spec_helper'

describe '#is_a, #is_an' do
  include Covenant::DSL

  describe 'assertion' do
    subject(:assertion) { assert('hi') }

    it "requires an argument of type Class" do
      expect { assertion.is_a('fake') }.to raise_error(ArgumentError)
    end

    it "passes if the receiver 'is a'" do
      expect { assertion.is_a(String) }.not_to raise_error
    end

    it "fails if the receiver 'is not a'" do
      expect { assertion.is_an(Array) }.
       to raise_error(Covenant::AssertionFailed, /must be/)
    end
  end

  describe 'denial' do
    subject(:denial) { deny('hi') }

    it "requires an argument of type Class" do
      expect { denial.is_a('fake') }.to raise_error(ArgumentError)
    end

    it "passes if the receiver 'is not a'" do
      expect { denial.is_an(Array) }.
       not_to raise_error(Covenant::AssertionFailed)
    end

    it "fails if the receiver 'is a'" do
      expect { denial.is_a(String) }.
       to raise_error(Covenant::AssertionFailed, /must not be/)
    end
  end
end
