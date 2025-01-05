---
template: main.html
---

# Development

## Package Layout :material-package-variant-closed:

The package contains files for building, testing, and continuous integration at its root, but it is broadly organized as shown below. Only the main components are included in this overview.

<pre>
WaLSAtools/
├── codes/
│   ├── python/                     # Python implementation of WaLSAtools
│   │   ├── WaLSAtools/             # Core library
│   │   ├── setup.py                # Setup script for Python
│   │   └── README.md               # Python-specific README
│   ├── idl/                        # IDL implementation of WaLSAtools
│   │   ├── WaLSAtools/             # Core library
│   │   ├── setup.pro               # Setup script for IDL
│   │   └── README.md               # IDL-specific README
├── docs/                           # Documentation for WaLSAtools
├── examples/                       # Worked examples directory
│   ├── python/                     # Python-specific examples
│   │   └── Worked_examples__NRMP/
│   ├── idl/                        # IDL-specific examples
│   │   └── Worked_examples__NRMP/
├── LICENSE                         # License information
├── NOTICE                          # Copyright Notice
└── README.md                       # Main repository README
</pre>

**Directory Structure**

Directory            | Description
-------------------- | -----------
`codes`              | Contains the main source codes, their associated analysis modules and *dependencies* for analysis tools in both Python and IDL. Subdirectories house any third-party components required for the package.
`docs`               | Contains the source files for documentation. Contributions to Markdown (`.md`) files under the root directory or *python* and *idl* subdirectories are welcome via pull requests. Other subdirectories manage the website's visual style and should not be edited. Images and PDF files should be stored in their respective subfolders.
`examples`           | Includes sample datasets and example scripts demonstrating how to use **WaLSAtools**.

**Key Files**

File                      | Description
------------------------- | -----------
`mkdocs.yml`              | Configuration file for generating the documentation website using MkDocs.
`WaLSAtools.py`           | The main Python script, serving as the core of WaLSAtools. This provides the essential framework for Python users.
`walsatools.pro`          | The main IDL script, providing the necessary framework for WaLSAtools in IDL. It is the primary entry point when using WaLSAtools in IDL.

## Editing Documents :material-file-document-edit:

All documentation is written in Markdown, with some additional syntax and extensions. It is converted to HTML using Python Markdown and deployed via [`gh-pages`][1]{target=_blank}. For those new to Markdown, you can learn about its syntax and structure [here][2]{target=_blank}. 

### Recommended Tools:
- **Markdown Editing**: Using [Visual Studio Code][3]{target=_blank}  is highly recommended for working with Markdown files and coding in Python, IDL, or other languages. To ensure an optimal experience, install all necessary extensions for Markdown and the relevant programming languages.
- **Contribution Process**: Edit Markdown files directly within the `docs` directory and submit your changes via pull requests. Always preview changes locally before pushing updates.

  [1]: https://www.mkdocs.org/user-guide/deploying-your-docs/
  [2]: https://www.markdownguide.org
  [3]: https://code.visualstudio.com/docs/languages/markdown

<br>
