//= require amcharts/ext/object_keys

AmCharts.RB.Chart = AmCharts.RB.Util.Class.create({
  initialize: function(chart)
  {
    this.chart = chart;
  },

  load_data: function(data)
  {
    this.chart.dataProvider = data;

    if (this.pie()) {
      if (AmCharts.RB.Util.is_empty(this.chart.titleField)) this.chart.titleField = this.title_field();
      if (AmCharts.RB.Util.is_empty(this.chart.valueField)) this.chart.valueField = this.value_field();
    }
    else
    {
      if (AmCharts.RB.Util.is_empty(this.chart.categoryField)) this.chart.categoryField = this.category_field();
    }


    this.chart.validateData();
    this.chart.animateAgain();
  },

  category_field: function()
  {
    if (this.chart.dataProvider.length == 0) return '';
    return Object.keys(this.chart.dataProvider[0])[0];
  },

  value_field: function()
  {
    if (this.chart.dataProvider.length == 0) return '';
    return Object.keys(this.chart.dataProvider[0])[1];
  },

  title_field: function()
  {
    if (this.chart.dataProvider.length == 0) return '';
    return Object.keys(this.chart.dataProvider[0])[0];
  },

  failed: function(message)
  {
    var blanket = AmCharts.RB.Helpers.get_blanket(this.chart.container.div),
      blanket_inner = blanket.childNodes[0].childNodes[0].childNodes[0];

    blanket.style.display = '';
    var error_div = document.createElement("DIV");
    error_div.className = 'chart-loading-error';
    error_div.appendChild(document.createTextNode(message));
    blanket_inner.innerHTML = "";
    blanket_inner.appendChild(error_div);
  },

  pie: function()
  {
    return this.chart.type === "pie";
  },

  serial: function()
  {
    return this.chart.type === "serial";
  }
});
