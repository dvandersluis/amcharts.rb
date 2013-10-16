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
end