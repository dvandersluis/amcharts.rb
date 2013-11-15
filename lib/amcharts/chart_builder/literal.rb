module AmCharts
  ChartBuilder::Literal = Struct.new(:name) do
    def to_json(options = {})
      name.to_s
    end
  end
end