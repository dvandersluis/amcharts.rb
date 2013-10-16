require "amcharts/version"
require_relative '../app/helpers/amcharts/amcharts_helper'

module AmCharts
  autoload :Chart,        'amcharts/chart'
  autoload :Graph,        'amcharts/graph'
  autoload :Legend,       'amcharts/legend'
  autoload :Set,          'amcharts/set'
  autoload :Settings,     'amcharts/settings'
  autoload :UsesSettings, 'amcharts/uses_settings'

  ActiveSupport::Inflector.inflections do |inflect|
    inflect.acronym "AmCharts"
  end

  Engine = Class.new(::Rails::Engine) do
    # Load the Amcharts helper when loading ActionView
    initializer 'amcharts.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper AmCharts::AmChartsHelper
      end
    end
  end if defined?(Rails)
end
