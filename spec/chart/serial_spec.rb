require 'amcharts/chart/serial'

describe AmCharts::Chart::Serial do
  its(:type) { should be_serial }
end