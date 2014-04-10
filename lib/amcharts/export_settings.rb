require 'amcharts/uses_settings'

module AmCharts
  class ExportSettings
    class Menu
      include UsesSettings

      def initialize(*)
        super

        if defined? Rails
          @settings.icon ||= ActionController::Base.helpers.asset_path('amcharts/export.png')
        end
      end

      def formats
        formats = []
        formats << @settings[:format].to_s.downcase.to_sym if @settings[:format]

        if @settings[:items]
          @settings[:items].each do |i|
            formats << i[:format].to_s.downcase.to_sym if i[:format]
          end
        end

        formats
      end
    end

    attr_reader :settings, :menus

    def initialize(&block)
      @settings = Settings.new
      @menus = Collection[Menu]
      instance_exec(self, &block) if block_given?
    end

    def pdf?
      return false if menus.empty?
      menus.flat_map(&:formats).any?{ |f| f == :pdf }
    end
  private

    def method_missing(name, *args, &block)
      @settings.send(name, *args, &block)
    end
  end
end