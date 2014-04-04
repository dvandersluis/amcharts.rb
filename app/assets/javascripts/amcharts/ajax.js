//= require ./util
//= require_self
//= require_tree ./ajax

AmCharts.RB.Ajax = function()
{
  function get_transport()
  {
    return AmCharts.RB.Util.try_these(
      function() {return new XMLHttpRequest()},
      function() {return new ActiveXObject('Msxml2.XMLHTTP')},
      function() {return new ActiveXObject('Microsoft.XMLHTTP')}
    ) || false;
  }

  function set_request_headers(method)
  {
    var headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Accept': 'text/javascript, text/html, application/xml, text/xml, */*'
    };

    if (method == 'POST')
    {
      headers['Content-type'] = "application/x-www-form-urlencoded; charset=UTF-8";

      /* Force "Connection: close" for older Mozilla browsers to work
       * around a bug where XMLHttpRequest sends an incorrect
       * Content-length header. See Mozilla Bugzilla #246651.
       */
      if ($transport.overrideMimeType && (navigator.userAgent.match(/Gecko\/(\d{4})/) || [0,2005])[1] < 2005)
        headers['Connection'] = 'close';
    }

    for (var name in headers) {
      $transport.setRequestHeader(name, headers[name]);
    }
  }

  var $transport = get_transport();

  return {
    transport: $transport,
    last_response: null,

    request: function(url, params, method, on_state_change)
    {
      method = method ? method.toUpperCase() : 'GET';
      params = AmCharts.isString(params) ? params : AmCharts.RB.Util.to_query_string(params);

      if (method != 'GET' && method != 'POST') {
        // simulate other verbs over post
        params += (params ? '&' : '') + "_method=" + method;
        method = 'POST';
      }

      if (params && method === 'GET') {
        // when GET, append parameters to URL
        url += (url.include('?') ? '&' : '?') + params;
      }

      $transport.open(method.toUpperCase(), url, true);
      this.last_response = new AmCharts.RB.Ajax.Response($transport);

      if (on_state_change && AmCharts.RB.Util.is_function(on_state_change)) {
        $transport.onreadystatechange = on_state_change;
      }

      set_request_headers(method);
      $transport.send(method === 'POST' ? params : null);
    }
  }
}();