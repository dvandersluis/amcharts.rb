//= require ./ajax

AmCharts.RB.RemoteJSONProvider = AmCharts.RB.Util.Class.create(function()
{
  function state_changed()
  {
    var response = this.request.response;

    if (response.ready_state() == 4)
    {
      if (response.status() == 200)
      {
        this.completed = true;
        this.started = false;

        this.data = response.get_json();
        if (this.chart) this.chart.load_data(this.data);
      }
      else if (this.chart)
      {
        this.chart.failed("Error loading chart data: " + this.url);
      }
    }
  }

  return {
    request: null,

    initialize: function(chart, url, params, method)
    {
      this.url = url;
      this.completed = this.started = false
      this.params = params;
      this.method = method || 'GET';

      if (chart) this.chart = new AmCharts.RB.Chart(chart);
    },

    load: function(defer)
    {
      this.started = true;

      setTimeout(function(){
        this.request = new AmCharts.RB.Ajax.Request(this.url, this.params, this.method, state_changed.bind(this));
      }.bind(this), defer || 0)
    },

    loaded: function()
    {
      return this.completed;
    },

    loading: function()
    {
      return !this.loaded() && this.started;
    }
  }
}());

