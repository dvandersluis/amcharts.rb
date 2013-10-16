module AmCharts
  class Graph
    attr_accessor :value_field, :type
    attr_accessor :chart

    def initialize(value_field, type)
      @value_field = value_field
      @type = type
    end
  end
end