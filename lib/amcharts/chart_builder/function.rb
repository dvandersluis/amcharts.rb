module AmCharts
  class ChartBuilder
    class Function
      attr_reader :name, :body

      def initialize(name, body = nil)
        @name, @body = name, body
      end

      def to_json
        body.nil? ? name.to_s : "function #{name}() { #{body} }"
      end
    end
  end
end