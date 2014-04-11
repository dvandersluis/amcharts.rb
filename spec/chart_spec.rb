require 'amcharts/chart'

describe AmCharts::Chart do
  describe "#dimensions" do
    context "setting width and height with the same assignment" do
      before { subject.dimensions = "800x600" }

      its(:width) { should == 800 }
      its(:height) { should == 600 }
    end

    context "not setting width and height" do
      its(:width) { should be_nil }
      its(:height) { should be_nil }
    end
  end

  describe "#new" do
    it "should add settings from the given block" do
      chart = described_class.new do |c|
        c.foo = :bar
      end

      chart.settings[:foo].should == :bar
    end
  end

  describe "#update_settings" do
    subject do
      described_class.new do |c|
        c.foo = :bar
      end
    end

    it "should add new settings" do
      subject.update_settings { |c| c.baz = :quux }
      subject.settings[:foo].should == :bar
      subject.settings[:baz].should == :quux
    end

    it "should override existing settings" do
      subject.update_settings { |c| c.foo = :baz }
      subject.settings[:foo].should == :baz
    end

    it "should return the chart" do
      subject.update_settings{}.should == subject
    end
  end
end