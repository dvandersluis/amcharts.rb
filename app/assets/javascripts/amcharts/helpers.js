AmCharts.RB.Helpers = {
  add_container_if_needed: function(id, width, height)
  {
    var container = document.getElementById(id);

    if (!container) {
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
  },

  add_loading_indicator: function(container, width, height, message, image_path) {
    var wrapper = document.createElement("DIV"),
      blanket = document.createElement("DIV"),
      blanket_container = document.createElement("DIV"),
      blanket_outer = document.createElement("DIV"),
      blanket_inner = document.createElement("DIV"),
      loading_div = document.createElement("DIV"),
      loading_image = document.createElement("IMG"),
      loading = document.createTextNode(message);

    wrapper.className = 'chart-wrapper';
    wrapper.id = container.id + "_wrapper"
    wrapper.style.width = width + 'px';
    wrapper.style.minHeight = height + 'px';

    container.style.width = '100%';

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
  },

  hide_loading_indicator: function(chart) {
    var container = chart.container.div;
    var wrapper = container;
    while ((" " + wrapper.className + " ").indexOf(" chart-wrapper ") < 0) {
      wrapper = wrapper.parentElement;
    }

    getElementsByClassName('chart-blanket', wrapper)[0].style.display = 'none';
  },

  add_legend_div: function(id, main_div) {
    var legend = document.getElementById(id);

    if (!legend) {
      legend = document.createElement("DIV");
      legend.className = 'chart-legend';
      legend.id = id;
      legend.style.width = main_div.getWidth() + 'px';

      var wrapper = main_div.parentNode;
      if (main_div.nextSibling) {
        wrapper.insertBefore(legend, main_div.nextSibling);
      }
      else {
        wrapper.appendChild(legend);
      }
    }

    return legend;
  }
}