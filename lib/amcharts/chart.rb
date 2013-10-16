require 'active_support/core_ext/string/inflections'
require 'active_support/string_inquirer'
require 'active_support/core_ext/array/access'
require 'amcharts'

module AmCharts
  class Chart
    autoload :Funnel,   'amcharts/chart/funnel'
    autoload :Gauge,    'amcharts/chart/gauge'
    autoload :Pie,      'amcharts/chart/pie'
    autoload :Radar,    'amcharts/chart/radar'
    autoload :Serial,   'amcharts/chart/serial'
    autoload :XY,       'amcharts/chart/xy'

    attr_accessor :data_provider, :container
    attr_accessor :width, :height
    attr_reader :titles, :graphs, :legends, :data

    def initialize(*data, &block)
      @data = data.flatten
      @graphs = Set.new(Graph)
      @legends = Set.new(Legend)
      @settings = Settings.new
      instance_exec(self, &block) if block_given?
    end

    def category_field
      @category_field || data.first.keys.first
    end

    def self.type
      ActiveSupport::StringInquirer.new(self.name.demodulize.downcase)
    end

    def self.amchart_type
      "AmCharts.Am#{type.to_s.titleize}Chart()"
    end

    def add_title(text, options = {})
      @titles ||= []
      @titles << [text, options.reverse_merge(size: 13, bold: true, alpha: 1, color: '#000000')]
    end

    def dimensions=(dim)
      @width, @height = dim.split("x").map(&:to_i)
    end

    def type
      self.class.type
    end

    def amchart_type
      self.class.amchart_type
    end

    def method_missing(name, *args, &block)
      return type.send(name) if type if name.to_s.end_with?('?')
      @settings.send(name, *args, &block)
    end
  private

    def initialize_graph_set
      # Create a new GraphSet that is bound to self so that new graphs can be associated back to the chart
      # Some chart type don't use graphs, so should override this method to return []
      GraphSet.new &(-> chart { proc{ |set| set.chart = chart } }).call(self)
    end
  end
end