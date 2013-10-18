module AmCharts
  class ChartBuilder
    attr_reader :template

    def initialize(template)
      @template = template
    end

    def to_js(val)
      val = t(val) if val.is_a?(Symbol)
      raw(val.to_json)
    end

    def render_data(chart)
      concat render(partial: 'amcharts/data.js.erb', locals: { chart: chart, builder: self })
    end

    def render_component(component, options = {}, &block)
      partial_name = component.respond_to?(:each) ? 'collection' : 'object'
      template_type = block_given? ? :layout : :partial
      concat render(template_type => "amcharts/#{partial_name}.js.erb", object: component, locals: options.merge(builder: self), &block)
    end

    def render_settings(object, name, index = nil)
      raise ArgumentError, "given object doesn't have settings" unless object.respond_to?(:settings)

      name.concat(index.to_s) if index

      object.settings.each do |key, value|
        concat render(partial: 'amcharts/settings.js.erb', locals: { name: name, key: key, value: value, builder: self })
      end
    end

    def render_title(chart)
      chart.titles.each do |(title, options)|
        concat render(partial: 'amcharts/title.js.erb', locals: { title: title, options: options, builder: self })
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