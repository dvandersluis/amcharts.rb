require 'active_support/core_ext/string/inflections'
require 'active_support/string_inquirer'
require 'active_support/core_ext/array/access'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/object/blank'
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

    class_attribute :default_settings
    attr_accessor :data_provider, :data_source, :container
    attr_accessor :width, :height, :loading_indicator
    attr_reader :titles, :labels, :graphs, :legends, :data, :settings, :listeners, :legend_div, :export, :functions

    delegate :language?, to: :settings

    def initialize(*data, &block)
      @data = data.flatten
      @data_source = DataSource.new
      @graphs = Collection[Graph]
      @legends = Collection[Legend]
      @listeners = Collection[Listener]
      @settings = Settings.new(self.class.defaults)
      @export = nil
      @titles = []
      @labels = []
      @functions = []

      update_settings(&block) if block_given?
    end

    class << self
      def defaults(&block)
        if block_given?
          self.default_settings ||= Settings.new
          instance_exec(self.default_settings, &block)
        else
          return {} if self.default_settings.blank?
          self.default_settings.to_h.symbolize_keys
        end
      end

      def clear_defaults
        self.default_settings = nil
      end
    end

    def update_settings(&block)
      instance_exec(self, &block)
      self
    end

    # Allow data to be loaded from a remote source
    def data_source=(source)
      @data_source = DataSource.new(source)
    end

    # Should remote data be loaded right away?
    def defer?
      @data_source.fetch(:defer, false)
    end

    def category_field
      @category_field || AmCharts::ChartBuilder::Function.new('new AmCharts.RB.Chart(chart).category_field()')
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

    def export?
      !@export.nil?
    end

    def export(&block)
      @export ||= ExportSettings.new
      yield @export if block_given?
      @export
    end
    alias_method :exportable!, :export

    def add_title(text, options = {})
      @titles << [text, options.reverse_merge(size: 13, bold: true, alpha: 1, color: '#000')]
    end

    def add_label(text, x, y, options = {})
      @labels << [text, x, y, options.reverse_merge(size: 11, align: 'left', color: '#000', rotation: 0, alpha: 1, bold: false)]
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

    # Show a loading indicator while the chart is rendering
    # A listener will automatically be added to hide the indicator when the rendered event
    # is received
    def loading_indicator!
      @loading_indicator = true
    end

    def loading_indicator?
      self.loading_indicator
    end

    def detach_legend(div = true)
      @legend_div = div
    end

    def process_data
      data.each.with_index { |row, index| yield row, index }
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

    def call_function(fn)
      @functions << fn
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
