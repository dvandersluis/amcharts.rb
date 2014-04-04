//= require amcharts/util
//= require amcharts/ajax/response
//= require_self

AmCharts.RB.Ajax.Request = AmCharts.RB.Util.Class.create({
  response: null,

  initialize: function(url, params, method, on_state_change)
  {
    this.transport = this.get_transport();

    this.url = url;
    this.method = method ? method.toUpperCase() : 'GET';
    this.params = AmCharts.isString(params) ? params : AmCharts.RB.Util.to_query_string(params);

    if (this.method != 'GET' && this.method != 'POST') {
      // simulate other verbs over post
      this.params += (this.params ? '&' : '') + "_method=" + this.method;
      this.method = 'POST';
    }

    if (this.params && this.method === 'GET') {
      // when GET, append parameters to URL
      this.url += (this.url.indexOf('?') > -1 ? '&' : '?') + this.params;
    }

    this.transport.open(this.method.toUpperCase(), this.url, true);
    this.response = new AmCharts.RB.Ajax.Response(this.transport);

    if (on_state_change && AmCharts.RB.Util.is_function(on_state_change)) {
      this.transport.onreadystatechange = on_state_change;
    }

    this.set_request_headers();
    this.transport.send(this.method === 'POST' ? this.params : null);
  },

  get_transport: function()
  {
    return AmCharts.RB.Util.try_these(
      function() {return new XMLHttpRequest()},
      function() {return new ActiveXObject('Msxml2.XMLHTTP')},
      function() {return new ActiveXObject('Microsoft.XMLHTTP')}
    ) || false;
  },

  set_request_headers: function()
  {
    var headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Accept': 'text/javascript, text/html, application/xml, text/xml, */*'
    };

    if (this.method == 'POST')
    {
      headers['Content-type'] = "application/x-www-form-urlencoded; charset=UTF-8";

      /* Force "Connection: close" for older Mozilla browsers to work
       * around a bug where XMLHttpRequest sends an incorrect
       * Content-length header. See Mozilla Bugzilla #246651.
       */
      if (this.transport.overrideMimeType && (navigator.userAgent.match(/Gecko\/(\d{4})/) || [0,2005])[1] < 2005)
        headers['Connection'] = 'close';
    }

    for (var name in headers) {
      this.transport.setRequestHeader(name, headers[name]);
    }
  }
});