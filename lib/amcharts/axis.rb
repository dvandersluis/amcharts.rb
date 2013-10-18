module AmCharts
  class Axis
    autoload :Category, 'amcharts/axis/category'
    autoload :Value,    'amcharts/axis/value'

    include UsesSettings
  end
end