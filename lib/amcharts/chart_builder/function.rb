module AmCharts
  ChartBuilder::Function = Struct.new(:name) do
    def to_json(options = {})
      name.to_s
    end
  end
end