require 'amcharts/settings'

module AmCharts
  class DataSource < Settings
    def defer!
      self.defer = true
    end

    def params
      @settings[:params] ||= {}
    end

    def params=(params)
      self.params.merge!(params)
    end
  end
end