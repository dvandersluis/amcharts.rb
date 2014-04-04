AmCharts.RB.Util = {
  try_these: function()
  {
    var returnValue;

    for (var i = 0, length = arguments.length; i < length; i++)
    {
      var lambda = arguments[i];

      try
      {
        returnValue = lambda();
        break;
      }
      catch (e) { }
    }

    return returnValue;
  },

  to_query_string: function(obj, prefix)
  {
    var str = [];

    for(var p in obj)
    {
      var k = prefix ? prefix + "[" + p + "]" : p, v = obj[p];

      str.push(typeof v == "object" ?
        AmCharts.RB.Util.to_query_string(v, k) :
        encodeURIComponent(k) + "=" + encodeURIComponent(v));
    }

    return str.join("&");
  },

  is_function: function(object)
  {
    return Object.prototype.toString.call(object) === "[object Function]";
  }
}