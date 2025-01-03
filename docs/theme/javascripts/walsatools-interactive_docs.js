document.addEventListener('DOMContentLoaded', () => {
    // Select links from both md-nav and md-tabs
    const navLinks = document.querySelectorAll('a.md-nav__link, a.md-tabs__link');
    navLinks.forEach(link => {
        link.addEventListener('click', event => {
            // Force a full page reload
            window.location.href = event.currentTarget.href;
            event.preventDefault();
        });
    });
});