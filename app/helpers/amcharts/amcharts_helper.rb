module AmCharts
  module AmChartsHelper
    def amchart(chart, container)
      # Load necessary JS files, without loading one more than once
      @loaded_amchart_files ||= []
      js_files = ['amcharts', "amcharts/#{chart.type}"] - @loaded_amchart_files
      @loaded_amchart_files += js_files

      content_for(:javascript) { javascript_include_tag(*js_files) }

      # Render the chart builder
      javascript_tag(render(file: 'amcharts/chart_builder.js.erb', locals: { builder: AmCharts::ChartBuilder.new(self), chart: chart, container: container }))
    end
  end
end