---
template: overrides/main.html
---

# Troubleshooting

## WaLSAtools not recognised

Operating systems:
:fontawesome-brands-apple:
:fontawesome-brands-linux:
:fontawesome-brands-windows:

!!! walsa-error "Error: Undefined procedure"

    ```sh
	IDL> WaLSAtools
	% Attempt to call undefined procedure: 'WALSATOOLS'.
	% Execution halted at: $MAIN$
    ```

If you run into this error, the most common reason is that your `IDL_PATH` is not set correctly, so the package's location cannot be recognised globally. Check out [Setting IDL PATH][1].

## An undefined procedure or keyword

Operating systems:
:fontawesome-brands-apple:
:fontawesome-brands-linux:
:fontawesome-brands-windows:

!!! walsa-error "Error: Syntax error"

    ```sh
	IDL> WaLSAtools
	....
	  param[*,i] = example_function(bla[*,i],t=t[j])
	                                 ^
	% Syntax error.
    ```

If IDL reports a `syntax error` the reason may not be immediately obvious. Check out the following common issues: 

=== "Undefined function"

    If IDL does not know a function, the function's name is considered as an array. Make sure the function is compiled before the error message. 
	If you have correctly followed the installation procedure, all IDL dependencies should have been added to the `IDL_PATH`.

=== "Procedure conflict"

    If you have another function or procedure in your `IDL_PATH` with the same name as that in question, then the wrong one (with different functionality and/or keywords) could be called instead. Check out the location of the function/procedure (see below) and make sure if that is under the WaLSAtools directory. 
	Otherwise, you may need to rename those (and in all places they are called).
	
    ```sh
    IDL> which, 'example_function'
	~/idlLibrary/WaLSAtools/codes/dependencies/example_function.pro
    ```

	Note that `which.pro` is part of [SolarSoft][11]{target=_blank}. If you do not have it installed, you should then search the function/procedure in your computer outside IDL (inside your IDL library, or all locations added to your `IDL_PATH`; also in the same directory in which you are running the IDL when the syntax error appeared).

=== "IDL version"

    In some IDL versions, a variable followed by parentheses, e.g., `x(i)`, is considered as a function (which likely does not exist). In such cases, the variable must be followed by square brackets as `x[i]`.

=== "Wrong syntax"

	A wrong syntax or a keyword (such as a typo) could also, in principle, cause `Syntax error`. However, this package has been tested extensively and should not be the case, but please let us know if you think this is the source of error.

!!! walsa-issues "Questions and Discussions"
    If there is still an issue with, e.g., the package installation, or if you have any other question, please submit your matter on our [**GitHub Discussions**][2]{target=_blank}. It is a forum hosted on GitHub. We will monitor and answer questions linked to **WaLSAtools** there.

<br>

  [1]: setting-idl-path.md
  [2]: https://github.com/WaLSAteam/WaLSAtools/discussions
  [11]: https://sohowww.nascom.nasa.gov/solarsoft/