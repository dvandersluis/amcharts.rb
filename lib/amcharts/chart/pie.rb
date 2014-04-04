require 'amcharts/chart'

module AmCharts
  class Chart::Pie < Chart
    attr_accessor :value_field, :title_field

    def title_field
      @title_field || AmCharts::ChartBuilder::Function.new('new AmCharts.RB.Chart(chart).title_field()')
    end

    def value_field
      @value_field || AmCharts::ChartBuilder::Function.new('new AmCharts.RB.Chart(chart).value_field()')
    end
  end
end