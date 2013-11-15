require 'amcharts/chart_builder/function'

describe AmCharts::ChartBuilder::Function do
  subject{ described_class.new(:func) }

  its(:to_json) { should == 'func' }
end