require 'spec_helper'

describe '#<query>' do
  include Covenant::DSL

  describe 'assertion' do
    subject(:assertion) { assert('hi') }

    it "passes if the receiver answers the query with a true value" do
      expect { assertion.start_with('h') }.not_to raise_error
    end

    it "fails if the receiver answers the query with a false value" do
      expect { assertion.end_with('a') }.
       to raise_error(Covenant::AssertionFailed, /must end_with "a"/)
    end
  end

  describe 'denial' do
    subject(:denial) { deny('hi') }

    it "passes if the answers the query with a false value" do
      expect { denial.start_with('o') }.
       not_to raise_error(Covenant::AssertionFailed)
    end

    it "fails if the receiver answers the query with a true value" do
      expect { denial.end_with('i') }.
       to raise_error(Covenant::AssertionFailed, /must not end_with "i"/)
    end
  end
end
