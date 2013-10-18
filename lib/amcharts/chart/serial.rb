require 'amcharts/chart'

module AmCharts
  class Chart::Serial < Chart::Rectangular
    def category_axis(&block)
      return @category_axis unless block_given?
      @category_axis ||= Axis::Category.new(&block)
    end
  end
end