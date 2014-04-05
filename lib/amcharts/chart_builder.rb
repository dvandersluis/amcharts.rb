module AmCharts
  class ChartBuilder
    autoload :Function, 'amcharts/chart_builder/function'
    autoload :Literal, 'amcharts/chart_builder/literal'

    attr_reader :template, :chart

    def initialize(chart, template)
      @chart = chart
      @template = template

      if @chart.loading_indicator? and @chart.data_source.empty?
        @chart.listeners.new(:rendered, 'AmCharts.RB.Helpers.hide_loading_indicator')
      end
    end

    def to_js(val)
      val = instance_exec(&val) if val.is_a?(Proc)
      val = t(val) if val.is_a?(Symbol)
      raw(val.to_json)
    end

    def render_js(name, options, &block)
      template_type = options.delete(:template_type) || :partial
      template_name = "amcharts/#{name}"

      options[:locals] = (options[:locals] || {}).merge(builder: self)
      options = { template_type => template_name }.merge(options)

      block_given? ? template.render(options, &block) : template.render(options)
    end

    def render_data
      concat render_js('data', locals: { chart: chart })
    end

    def render_data_source
      return if chart.data_source.empty?
      url = chart.data_source[:url]
      params = chart.data_source.fetch(:params, {})
      method = chart.data_source.fetch(:method, 'GET')
      concat render_js('data_source', object: url, locals: { params: params, method: method })
    end

    def render_component(component, options = {}, &block)
      return unless component
      partial_name = component.respond_to?(:each) ? 'collection' : 'object'
      template_type = block_given? ? :layout : :partial
      concat render_js(partial_name, template_type: template_type, object: component, locals: options, &block)
    end

    def render_legend
      chart.legends.each do |l|
        div = chart.legend_div == true ? "#{chart.container}_legend" : chart.legend_div
        concat render_js('legend', object: l, locals: { div: div })
      end
    end

    def render_settings(object, name, index = nil)
      raise ArgumentError, "given object doesn't have settings" unless object.respond_to?(:settings)

      name.concat(index.to_s) if index

      object.settings.each do |key, value|
        concat render_js('settings', locals: { name: name, key: key, value: value })
      end
    end

    def render_title
      chart.titles.each do |(title, options)|
        concat render_js('title', locals: { title: title, options: options })
      end
    end

    def render_listeners()
      chart.listeners.each do |listener|
        concat render_js('listener', locals: { type: listener.type, method: listener.method })
      end
    end

  private

    def method_missing(*args, &block)
      return template.send(*args, &block) if template.respond_to?(args.first)
      super
    end

    def respond_to_missing?(*args)
      return true if template.respond_to?(*args)
      super
    end
  end
end