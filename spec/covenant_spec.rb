require 'spec_helper'

describe Covenant do
  describe Covenant::DSL do
    include Covenant::DSL

    describe "#assert" do
      subject { assert(:something) }

      it { should be_a(Covenant::Assertion) }
    end

    describe "#deny" do
      subject { deny(:something) }

      it { should be_a(Covenant::Denial) }
    end
  end
end
