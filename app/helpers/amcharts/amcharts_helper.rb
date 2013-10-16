module AmCharts
  module AmChartsHelper
    def amchart(chart, container)
      # Load necessary JS files
      content_for(:javascript) { javascript_include_tag('amcharts', "amcharts/#{chart.type}") }

      # Render the chart
      javascript_tag(render(file: 'amcharts/chart.js.erb', locals: { chart: chart, container: container }))
    end

    def to_js(val)
      raw val.to_json
    end
  end
end