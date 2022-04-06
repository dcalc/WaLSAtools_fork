---
template: main.html
---

# Development

## Package Layout :material-package-variant-closed:

There are a number of files for build, test, and continuous integration in the root of the package, but in general, it is broken up as illustrated below. Individual files, except the **WaLSAtools** main code and docs setup file, are not shown in the layout.

```
.
├── codes
│   ├── idl
│   │   ├── dependencies_level1
│   │   ├── dependencies_level2
│   │   └── walsatools.pro
│   └── python
│       └── dependencies
├── docs
│   ├── idl
│   ├── python
│   ├── images
│   ├── pdf
│   ├── releases
│   └── theme
├── examples
│   ├── idl
│   ├── python
│   └── sample_data
└── mkdocs.yml
```

Directory            | Description
-------------------- | -----------
`codes`              | This contains the main source codes (and their *dependencies*) for all analysis tools in both IDL and Python programming languages. Further sub-directories include third party components required for the package, as well as the `epstool-3.08` package which is a utility to, e.g., fix bounding boxes, in EPS files.
`docs`               | This contains the source files for the documentations. Pull request for changes of the Markdown (.md) files under the root level of the directory and under *idl* and *python* directories can be submitted. Other sub-directories include files for style of the web document and should not be changed. Images and PDF files should be put in the associated folders.
`examples`           | This contains various examples on sample data sets (stored in the `sample_data` folder under this directory) to show how WaLSAtools can be used.

Files                      | Description
-------------------------- | -----------
`mkdocs.yml`               | The main configuration file for this documentation.
`walsatools.pro`           | The main IDL code which provides all necessary information. This is the prime (only) code which should preferably be called when using WaLSAtools in IDL.

## Editing Documents :material-file-document-edit:

Documents are in Markdown (with some additional syntax and extensions) and converted to HTML via Python Markdown (deployed using [`gh-pages`][1]{target=_blank}). To edit the documents, find out about Markdown and how it works [here][2]{target=_blank}. Working with Markdown in [Visual Studio Code][3]{target=_blank} (when all Markdown extensions installed) is simple and recommended.

  [1]: https://www.mkdocs.org/user-guide/deploying-your-docs/
  [2]: https://www.markdownguide.org
  [3]: https://code.visualstudio.com/docs/languages/markdown

<br>
