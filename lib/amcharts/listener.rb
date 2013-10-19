module AmCharts
  class Listener
    attr_accessor :type, :method

    def initialize(type, method)
      @type = type
      @method = method
    end
  end
end