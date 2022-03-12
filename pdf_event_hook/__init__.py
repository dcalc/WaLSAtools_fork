import logging

from bs4 import BeautifulSoup
from mkdocs.structure.pages import Page


def inject_link(html: str, href: str,
                page: Page, logger: logging) -> str:
    """Adding PDF View button on navigation bar(using material theme)"""

    def _pdf_icon():
        _ICON = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 10.5h1v3h-1v-3m-5 1h1v-1H7v1M20 6v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2M9.5 10.5A1.5 1.5 0 0 0 8 9H5.5v6H7v-2h1a1.5 1.5 0 0 0 1.5-1.5v-1m5 0A1.5 1.5 0 0 0 13 9h-2.5v6H13a1.5 1.5 0 0 0 1.5-1.5v-3m4-1.5h-3v6H17v-2h1.5v-1.5H17v-1h1.5V9z"/></svg>
'''  # noqa: E501
        return BeautifulSoup(_ICON, 'html.parser')

    logger.info('(hook on inject_link: %s)', page.title)
    soup = BeautifulSoup(html, 'html.parser')

    nav = soup.find(class_='md-header-nav')
    if not nav:
        # after 7.x
        nav = soup.find('nav', class_='md-header__inner')
    if nav:
        a = soup.new_tag('a', href=href, title='PDF',
                         **{'class': 'md-header-nav__button md-icon'})
        a.append(_pdf_icon())
        nav.append(a)
        return str(soup)

    return html


# def pre_js_render(soup: BeautifulSoup, logger: logging) -> BeautifulSoup:
#     logger.info('(hook on pre_js_render)')
#     return soup


# def pre_pdf_render(soup: BeautifulSoup, logger: logging) -> BeautifulSoup:
#     logger.info('(hook on pre_pdf_render)')
#     tag = soup.find(lambda tag: tag.name ==
#                     'body' and 'data-md-color-scheme' in tag.attrs)
#     if tag:
#         tag['data-md-color-scheme'] = 'print'
#     return soup
