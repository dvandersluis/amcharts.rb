module AmCharts
  class Legend
    attr_reader :settings, :listeners

    def initialize(&block)
      @settings = Settings.new
      @listeners = Collection[Listener]
      instance_exec(self, &block) if block_given?
    end

  private

    def method_missing(name, *args, &block)
      @settings.send(name, *args, &block)
    end
  end
end