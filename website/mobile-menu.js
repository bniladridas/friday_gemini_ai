document.addEventListener('DOMContentLoaded', function() {
  var toggle = document.querySelector('.mobile-menu-toggle');
  var menu = document.querySelector('.nav-links-container');

  if (!toggle || !menu) return;

  toggle.addEventListener('click', function(e) {
    e.stopPropagation();
    var isOpen = menu.classList.contains('active');

    if (isOpen) {
      menu.classList.remove('active');
      toggle.classList.remove('active');
    } else {
      menu.classList.add('active');
      toggle.classList.add('active');
    }
  });

  document.addEventListener('click', function(e) {
    if (!toggle.contains(e.target) && !menu.contains(e.target)) {
      menu.classList.remove('active');
      toggle.classList.remove('active');
    }
  });

  var links = menu.querySelectorAll('a');
  for (var i = 0; i < links.length; i++) {
    links[i].addEventListener('click', function() {
      menu.classList.remove('active');
      toggle.classList.remove('active');
    });
  }
});
