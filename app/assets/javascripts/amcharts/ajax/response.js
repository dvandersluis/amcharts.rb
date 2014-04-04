//= require json2

AmCharts.RB.Ajax.Response = function(transport) {
  var $transport = transport;

  return {
    status: function() { return $transport.status },
    status_text: function() { return $transport.statusText },
    ready_state: function() { return $transport.readyState },

    get_header: function(name)
    {
      try {
        return $transport.getResponseHeader(name) || null;
      } catch (e) { return null; }
    },

    get_json: function()
    {
      try {
        return JSON.parse($transport.responseText);
      } catch(e) { return null; }
    }
  }
};

