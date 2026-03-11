document.addEventListener('DOMContentLoaded', () => {
  // Modern reveal animation for sections
  const sections = document.querySelectorAll('section');
  sections.forEach((section, index) => {
    section.style.opacity = '0';
    section.style.transform = 'translateY(10px)';
    section.style.transition = 'opacity 0.5s ease-out, transform 0.5s ease-out';

    setTimeout(() => {
      section.style.opacity = '1';
      section.style.transform = 'translateY(0)';

      // Clear inline transform after transition ends to allow CSS hover effects
      section.addEventListener('transitionend', function handler() {
        section.style.transform = '';
        section.removeEventListener('transitionend', handler);
      });
    }, 150 * index);
  });


});
