# AmCharts.rb [![Gem Version](https://badge.fury.io/rb/amcharts.rb.svg)](http://badge.fury.io/rb/amcharts.rb) [![Build Status](https://travis-ci.org/dvandersluis/amcharts.rb.svg?branch=master)](https://travis-ci.org/dvandersluis/amcharts.rb)

Ruby on Rails wrapper for creating AmCharts charts.

## Usage

A chart is represented by a subclass of `AmCharts::Chart` (ie. `Pie` or `Serial`), which is initialized with a data collection (should be an array
of homogeneous hashes), and some settings passed into a block:

    chart = AmCharts::Chart::Serial.new(data) do |c|
      add_title 'My Fancy Chart', size: 18
      loading_indicator!

      c.dimensions = '800x600'

      legends.new do |l|
        l.position = 'right'
        l.value_text = '[[percents]]%'
      end

      scrollbar {}
    end

The setup block accepts a number of methods for ease of setting up a chart, and accepts any other assignment method as a setting
that will be passed directly to AmCharts when the chart is rendered. Chart components including graphs, legends, axes, scrollbars and
cursors can also be added and configured using inner blocks. Listeners can also be defined in a similar manner.

Values in the setup block can be numeric or string literals (which will be passed along as is); symbols (which will be
given to `I18n.t` before being rendered); procs (which will be executed); or the `function()` method (which will act as
a literal javascript function).

An `AmCharts::Chart` object can then be rendered using the `amcharts` helper:

    amcharts(chart, 'id-of-container')

If the container ID given doesn't already exist in the page, it will be automatically created before the chart is rendered
by AmCharts.

### Chart setup methods
* `add_title(text, options: {})`: Adds a title element to the chart. `options` can be used to specify `size`, `bold` (`true`
or `false`), `alpha` (`0..1`), and/or `color` (a hex color code).
* `loading_indicator!`: Displays a loading indicator over the chart until it has completed rendering. The indicator makes use of
an I18n key (`chart_data_loading`) and an image (`amcharts/loading.gif`) which both can be customized within your application.
* `detach_legend(div: true)`: Makes the legend (if present) render in a separate div. `div` can either be `true` (which will
cause the legend div to be given an ID the same as the main div, with a "_legend" suffix), or the ID you want to give the div.
* `dimensions=('widthxheight')`: Allows width and height to be specified in one line

### Defining a chart
* Serial charts need to have their `graphs` defined on setup (this also allows multiple graphs to be defined; ie. for a multi-line chart).
Graphs are initialized with `(name, type)`, where `type` is a [type of graph](http://docs.amcharts.com/javascriptcharts/AmGraph#type)
that AmCharts is aware of (`:column`, `:line`, `:step`, etc.)

        AmCharts::Chart::Serial.new(data) do
          [:col1, :col2, :col3].each do |column|
          graphs.new(column, :smoothedLine) do |g|
            g.title = column
          end
        end

* Pie charts do not use `graphs`, as they get their values directly from the given data set.

### Note about the Version Number
The version number correlates to the version of AmCharts that is included (ie. 3.1.1.0 is the first release of
amcharts.rb which uses AmCharts v3.1.1)

## Using a Commercial AmCharts license

If you have purchased the commercial version of AmCharts, place the amcharts.js file it comes with inside a
`javascripts/amcharts` directory within `(app|lib|vendor)/assets`, so that it will be used instead of the free
version that is included in this gem.

## Installation

Add this line to your application's Gemfile:

    gem 'amcharts.rb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amcharts.rb

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgments

* Built upon the excellent [AmCharts Javascript V3](http://www.amcharts.com/javascript-charts/) charting package.
* Special thanks to [TalentNest](http://github.com/talentnest), who sponsored this gem's development.
