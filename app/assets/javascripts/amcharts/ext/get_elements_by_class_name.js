// Add indexOf and getElementsByClassName methods
// See: http://stackoverflow.com/questions/13261506/getelementsbyclassname-in-ie8
(function() {
  var indexOf = [].indexOf || function(prop) {
    for (var i = 0; i < this.length; i++) {
      if (this[i] === prop) return i;
    }
    return -1;
  };

  window.getElementsByClassName = function(className,context) {
    if (context.getElementsByClassName) return context.getElementsByClassName(className);
    var elems = document.querySelectorAll ? context.querySelectorAll("." + className) : (function() {
      var all = context.getElementsByTagName("*"),
        elements = [],
        i = 0;
      for (; i < all.length; i++) {
        if (all[i].className && (" " + all[i].className + " ").indexOf(" " + className + " ") > -1 && indexOf.call(elements,all[i]) === -1) elements.push(all[i]);
      }
      return elements;
    })();
    return elems;
  };
})();