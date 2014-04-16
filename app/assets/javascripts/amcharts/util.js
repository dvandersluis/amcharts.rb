AmCharts.RB.Util = {
  Class: {
    create: function(block) {
      function klass() {
        this.initialize.apply(this, arguments);
      }

      klass.prototype = block || {};
      if (!klass.prototype.initialize) klass.prototype.initialize = function() {}
      klass.prototype.constructor = klass;
      return klass;
    }
  },

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

    if (AmCharts.ifArray(obj))
    {
      for (var i = 0; i < obj.length; i++)
      {
        var k = prefix ? prefix + "[]" : "[]", v = obj[i];
        str.push(encodeURIComponent(k) + '=' + encodeURIComponent(v));
      }
    }
    else {
      for (var p in obj) {
        if (!obj.hasOwnProperty(p)) continue;
        var k = prefix ? prefix + "[" + p + "]" : p, v = obj[p];

        str.push(typeof v == "object" ?
          AmCharts.RB.Util.to_query_string(v, k) :
          encodeURIComponent(k) + "=" + encodeURIComponent(v));
      }
  }

    return str.join("&");
  },

  is_function: function(object)
  {
    return Object.prototype.toString.call(object) === "[object Function]";
  },

  is_empty: function(object)
  {
    if (object === null || object === undefined) return true;
    if (object.length !== undefined) return object.length == 0;
    return undefined;
  }
}