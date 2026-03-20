document.addEventListener('DOMContentLoaded', () => {
  // Cookie Banner
  const cookieBanner = document.getElementById('cookie-banner');
  const cookieAccept = document.getElementById('cookie-accept');
  const cookieDecline = document.getElementById('cookie-decline');

  const cookieConsent = localStorage.getItem('cookieConsent');

  if (cookieConsent) {
    cookieBanner.classList.add('hidden');
  } else if (cookieBanner) {
    cookieBanner.classList.add('visible');
  }

  if (cookieAccept) {
    cookieAccept.addEventListener('click', () => {
      localStorage.setItem('cookieConsent', 'accepted');
      cookieBanner.classList.add('hidden');
    });
  }

  if (cookieDecline) {
    cookieDecline.addEventListener('click', () => {
      localStorage.setItem('cookieConsent', 'declined');
      cookieBanner.classList.add('hidden');
    });
  }

  // Modern reveal animation for sections
  const sections = document.querySelectorAll('section');
  sections.forEach((section, index) => {
    section.style.opacity = '0';
    section.style.transform = 'translateY(10px)';
    section.style.transition = 'opacity 0.5s ease-out, transform 0.5s ease-out';

    setTimeout(() => {
      section.style.opacity = '1';
      section.style.transform = 'translateY(0)';

      section.addEventListener('transitionend', function handler() {
        section.style.transform = '';
        section.removeEventListener('transitionend', handler);
      });
    }, 150 * index);
  });

  // Mobile Menu Toggle
  const menuToggle = document.querySelector('.mobile-menu-toggle');
  const navLinksContainer = document.querySelector('.nav-links-container');

  if (menuToggle && navLinksContainer) {
    menuToggle.addEventListener('click', (e) => {
      e.stopPropagation();
      navLinksContainer.classList.toggle('active');
    });

    document.addEventListener('click', (e) => {
      if (!menuToggle.contains(e.target) && !navLinksContainer.contains(e.target)) {
        navLinksContainer.classList.remove('active');
      }
    });

    const navLinks = navLinksContainer.querySelectorAll('a');
    navLinks.forEach(link => {
      link.addEventListener('click', () => {
        navLinksContainer.classList.remove('active');
      });
    });
  }
});
