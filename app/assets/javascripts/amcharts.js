/*
 *= require amcharts/amcharts
*/

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

function add_container_if_needed(id, width, height)
{
  var container = document.getElementById(id);

  if (!container)
  {
    container = document.createElement("DIV");
    container.className = 'chart';
    container.id = id;
    container.style.width = width + 'px';
    container.style.height = height + 'px';

    // Add the container before the last script
    var scripts = document.getElementsByTagName('script');
    var this_script = scripts[scripts.length - 1];
    this_script.parentNode.insertBefore(container, this_script);
  }

  return container;
}

function add_loading_indicator(container, width, height, message, image_path)
{
  var wrapper = document.createElement("DIV"),
      blanket = document.createElement("DIV"),
      blanket_container = document.createElement("DIV"),
      blanket_outer = document.createElement("DIV"),
      blanket_inner = document.createElement("DIV"),
      loading_div = document.createElement("DIV"),
      loading_image = document.createElement("IMG"),
      loading = document.createTextNode(message);

  wrapper.className = 'chart-wrapper';
  wrapper.style.width = width + 'px';
  wrapper.style.height = height + 'px';

  blanket.className = 'chart-blanket';

  loading_div.className = 'chart-loading';
  loading_image.className = 'chart-loading-image';
  loading_image.src = image_path;

  container.parentNode.insertBefore(wrapper, container);

  blanket_container.appendChild(blanket_outer)
  blanket_outer.appendChild(blanket_inner);
  blanket_inner.appendChild(loading_div);
  loading_div.appendChild(loading);
  blanket_inner.appendChild(loading_image);

  blanket.appendChild(blanket_container);
  wrapper.appendChild(blanket);
  wrapper.appendChild(container);
}

function hide_loading_indicator(chart)
{
  var container = chart.container.div;
  var wrapper = container;
  while ((" " + wrapper.className + " ").indexOf(" chart-wrapper ") < 0)
  {
    wrapper = wrapper.parentElement;
  }

  getElementsByClassName('chart-blanket', wrapper)[0].style.display = 'none';
}