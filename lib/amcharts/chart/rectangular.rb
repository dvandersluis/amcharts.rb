require 'amcharts/chart'

module AmCharts
  class Chart::Rectangular < Chart
    attr_reader :value_axes

    def initialize(*)
      @value_axes = Set[Axis::Value]
      super
    end

    def cursor(&block)
      return @cursor unless block_given?
      @cursor ||= Cursor.new(&block)
    end

    def scrollbar(&block)
      return @scrollbar unless block_given?
      @scrollbar ||= ScrollBar.new(&block)
    end
  end
end