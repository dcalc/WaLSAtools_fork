document.addEventListener('DOMContentLoaded', () => {
    const navLinks = document.querySelectorAll('a.md-nav__link');
    navLinks.forEach(link => {
        link.addEventListener('click', event => {
            // Force a full page reload
            window.location.href = event.currentTarget.href;
            event.preventDefault();
        });
    });
});