module AmCharts
  class Graph
    attr_accessor :value_field, :type
    attr_accessor :chart

    include UsesSettings

    def initialize(value_field, type)
      super
      @value_field = value_field
      @type = type
    end
  end
end