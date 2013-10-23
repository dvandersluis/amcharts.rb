require 'active_support/core_ext/string/inflections'
require 'active_support/string_inquirer'
require 'active_support/core_ext/array/access'
require 'amcharts'

module AmCharts
  class Chart
    autoload :Funnel,       'amcharts/chart/funnel'
    autoload :Gauge,        'amcharts/chart/gauge'
    autoload :Pie,          'amcharts/chart/pie'
    autoload :Radar,        'amcharts/chart/radar'
    autoload :Rectangular,  'amcharts/chart/rectangular'
    autoload :Serial,       'amcharts/chart/serial'
    autoload :XY,           'amcharts/chart/xy'

    attr_accessor :data_provider, :container
    attr_accessor :width, :height, :loading_indicator
    attr_reader :titles, :graphs, :legends, :data, :settings, :listeners, :legend_div

    def initialize(*data, &block)
      @data = data.flatten
      @graphs = Collection[Graph]
      @legends = Collection[Legend]
      @listeners = Collection[Listener]
      @settings = Settings.new
      @titles = []
      instance_exec(self, &block) if block_given?
    end

    def category_field
      @category_field || data.first.keys.first
    end

    def keys
      data.first.keys
    end

    def self.type
      ActiveSupport::StringInquirer.new(self.name.demodulize.downcase)
    end

    def self.amchart_type
      "AmCharts.Am#{type.to_s.titleize}Chart()"
    end

    def add_title(text, options = {})
      @titles << [text, options.reverse_merge(size: 13, bold: true, alpha: 1, color: '#000000')]
    end

    def width=(w)
      @width = get_dimension_value(w)
    end

    def height=(h)
      @height = get_dimension_value(h)
    end

    def dimensions=(dim)
      @width, @height = dim.split("x").map(&:to_i)
    end

    def loading_indicator!
      @loading_indicator = true
      listeners.new(:rendered, :hide_loading_indicator)
    end

    def loading_indicator?
      self.loading_indicator
    end

    def detach_legend(div = true)
      @legend_div = div
    end

    def process_data
      data.each { |row| yield row }
    end

    def type
      self.class.type
    end

    def amchart_type
      self.class.amchart_type
    end

    # Axes are only defined for rectangular charts
    def category_axis
      nil
    end

    def value_axes
      []
    end

  private

    def get_dimension_value(value)
      value.respond_to?(:call) ? value.call(data) : value
    end

    # Delegate unknown messages to the settings object
    def method_missing(name, *args, &block)
      return type.send(name) if type if name.to_s.end_with?('?')
      @settings.send(name, *args, &block)
    end
  end
end