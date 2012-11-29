require 'spec_helper'

describe '#is' do
  include Covenant::DSL

  describe 'assertion' do
    subject(:assertion) { assert('hi') }

    it "passes if the receiver answers the query with a true value" do
      expect { assertion.is_ascii_only }.not_to raise_error
    end

    it "fails if the receiver answers the query with a false value" do
      expect { assertion.is_empty }.
       to raise_error(Covenant::AssertionFailed, /must be empty/)
    end
  end

  describe 'denial' do
    subject(:denial) { deny('hi') }

    it "passes if the answers the query with a false value" do
      expect { denial.is_empty }.
       not_to raise_error(Covenant::AssertionFailed)
    end

    it "fails if the receiver answers the query with a true value" do
      expect { denial.is_ascii_only }.
       to raise_error(Covenant::AssertionFailed, /must not be ascii_only/)
    end
  end
end
