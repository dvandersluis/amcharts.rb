require 'amcharts/chart'

module AmCharts
  class Chart::Pie < Chart
    attr_accessor :value_field, :title_field

    def title_field
      @title_field || data.first.keys.first
    end

    def value_field
      @value_field || data.first.keys.second
    end
  end
end