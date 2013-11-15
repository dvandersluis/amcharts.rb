require 'amcharts/chart_builder/literal'

describe AmCharts::ChartBuilder::Literal do
  subject{ described_class.new('a.b.c') }

  its(:to_json) { should == 'a.b.c' }
end