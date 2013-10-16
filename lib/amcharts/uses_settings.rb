module AmCharts
  module UsesSettings
    attr_reader :settings

    def initialize(*)
      @settings = Settings.new
      yield @settings if block_given?
    end
  end
end