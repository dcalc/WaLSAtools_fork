---
template: main.html
---

# Troubleshooting

This page provides solutions to common issues encountered during the installation or usage of WaLSAtools in IDL. If you encounter a problem not listed here, please refer to the [WaLSAtools documentation](https://walsa.tools) or [contact us](mailto:walsatools@gmail.com) for assistance.

## WaLSAtools Not Recognized

**Operating systems:**

* macOS
* Linux
* Windows

!!! walsa-error "Error: Undefined procedure"

    ```
    IDL> WaLSAtools
    % Attempt to call undefined procedure: 'WALSATOOLS'.
    % Execution halted at: $MAIN$
    ```

If you encounter this error, it usually means that your `IDL_PATH` is not set correctly, and IDL cannot find the WaLSAtools package. Please check the [Setting IDL PATH][1] page for instructions on how to configure your `IDL_PATH` correctly.

## Undefined Procedure or Keyword

**Operating systems:**

* macOS
* Linux
* Windows

!!! walsa-error "Error: Syntax error"

    ```
    IDL> WaLSAtools
    ...
      param[*,i] = example_function(bla[*,i],t=t[j])
                                     ^
    % Syntax error.
    ```

If IDL reports a `syntax error`, the reason might not be immediately obvious. Here are some common causes:

=== "Undefined function"

    If IDL doesn't recognize a function, it might interpret the function's name as an array. Make sure the function is compiled before the line where the error occurs. If you have installed WaLSAtools correctly, all its dependencies should have been added to your `IDL_PATH`.

=== "Procedure conflict"

    If you have another function or procedure with the same name in your `IDL_PATH`, IDL might be calling the wrong one. To check the location of the function/procedure, use the `which` command in IDL:

    ```idl
    IDL> which, 'example_function'
    ~/idlLibrary/WaLSAtools/codes/dependencies/example_function.pro
    ```

    This will show you the path to the `example_function.pro` file. Ensure that the file is located within the WaLSAtools directory. If not, you might need to rename the conflicting function/procedure in your path.

    Note that the `which` command is part of [SolarSoft][11]{target=_blank}. If you don't have SolarSoft installed, you can search for the function/procedure manually in your IDL library or the directories included in your `IDL_PATH`.

=== "IDL version"

    In some older IDL versions, using parentheses to index an array, like `x(i)`, might be interpreted as a function call. If you encounter this issue, use square brackets for indexing: `x[i]`.

=== "Wrong syntax"

    A simple typo or incorrect syntax can also cause a `Syntax error`. While WaLSAtools has been extensively tested, please let us know if you find any such errors.

!!! walsa-issues "Questions and Discussions"

    If you have any further questions or issues with WaLSAtools, please submit them on our [GitHub Discussions][2]{target=_blank} page. We actively monitor this forum and will be happy to assist you.

<br>

  [1]: setting-idl-path.md
  [2]: https://github.com/WaLSAteam/WaLSAtools/discussions
  [11]: https://sohowww.nascom.nasa.gov/solarsoft/