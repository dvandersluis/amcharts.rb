/*
 *= require amcharts/amcharts
*/

function add_container_if_needed(id, width, height)
{
  if (!document.getElementById(id))
  {
    var container = document.createElement("DIV");
    container.className = 'chart';
    container.id = id;
    container.style.width = width + 'px';
    container.style.height = height + 'px';

    // Add the container before the last script
    var scripts = document.getElementsByTagName('script');
    var this_script = scripts[scripts.length - 1];
    this_script.parentNode.insertBefore(container, this_script);
  }
}