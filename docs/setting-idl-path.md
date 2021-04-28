---
template: overrides/main.html
title: IDL PATH
---

# Setting IDL PATH

After you have [installed][1] **WaLSAtools**, you should make sure its path is added to your `IDL_PATH`. The `IDL_PATH` determines directories from which IDL searches for `.pro` files (i.e., IDL procedures and functions). 

The IDL search path is set differently in various operating systems (as well as in different shell environments in :fontawesome-brands-apple: and :fontawesome-brands-linux:). Hints for the most common environments are given below. Detailed instructions can be found at [IDL's support pages][2]{target=_blank}. 

## Using Terminal  :fontawesome-solid-terminal:

You can define and add custom search paths to your `IDL_PATH` system environment variable in terminal.

=== "Mac OS X and Linux"
    On Unix type systems, like Mac OS X and Linux, first determine what shell you are using. Type the following command in a terminal and press ++enter++ 
	```sh
	echo $0
	```
	You may also use other commands for this, but note that some other commands, like the the one given below, returns the shell for the current user but not necessarily the shell that is running at the moment.
	```sh
	echo $SHELL
	```
	The most common shells are `bash` (Bourne Again shell) and `csh` (C shell)/`tcsh` (TC shell), for which, customisation of the `IDL_PATH` are shown below.
	
    === "bash"
	    Add the the following lines to your `.bashrc` (located in your home directory; `~/`) or wherever you set the `IDL_PATH` variable (open the setup script with a text editor and add the lines somewhere in the file).
        ```
		export IDL_DIR=PATH-TO-IDL-DIRECTORY
		export IDL_PATH=+${IDL_DIR}/lib:+PATH-TO-THE-DIRECTORY/WaLSAtools
        ```
		where `PATH-TO-IDL-DIRECTORY` and `PATH-TO-THE-DIRECTORY` are the locations of IDL and `WaLSAtools` directories (in your computer), respectively. You may add as many packages/libraries as you want to the end of the `IDL_PATH` separating them with `:+`
		
		Finally, after adding the lines and saving the setup script, type the following command in terminal and press ++enter++
        ```
		source ~/.bashrc
        ```
    === "csh / tcsh"
	    Add the the following lines to your `.cshrc` or `.tcshrc` (located in your home directory; `~/`) or wherever you set the `IDL_PATH` variable (open the setup script with a text editor and add the lines somewhere in the file).
        ```
		setenv IDL_DIR PATH-TO-IDL-DIRECTORY
        setenv IDL_PATH +$IDL_DIR/lib:+PATH-TO-THE-DIRECTORY/WaLSAtools
        ```
		where `PATH-TO-IDL-DIRECTORY` and `PATH-TO-THE-DIRECTORY` are the locations of IDL and `WaLSAtools` directories (in your computer), respectively. You may add as many packages/libraries as you want to the end of the `IDL_PATH` separating them with `:+`
		
		Finally, after adding the lines and saving the setup script, type one of the following commands (depending on your shell environment) in terminal and press ++enter++
        ```
		source ~/.cshrc
        ```
		or 
        ```
		source ~/.tcshrc
        ```

=== "Microsoft Windows"
	Start the Environment Variables dialog:
    ```sh
	Start > Control Panel > System and Security > System > Advanced system settings > Advanced > Environment Variables
	```
    (on Windows 7 select)
	
	Then, set an `IDL_PATH`. If this environment variable does not already exist, create a New... System or User variable named: `IDL_PATH`.

	Finally, define the IDL packages/libraries in your path. 
    ```
    +C:\Program Files\PATH-TO-IDL-DIRECTORY\lib;C:PATH-TO-THE-DIRECTORY/WaLSAtools
    ```
	where `PATH-TO-IDL-DIRECTORY` and `PATH-TO-THE-DIRECTORY` are the locations of IDL and `WaLSAtools` directories (in your computer), respectively. You may add as many packages/libraries as you want to the end of the `IDL_PATH` separating them with `;` character, with no space added anywhere.

## Using IDL Workbench :material-cog-box:

The `IDL_PATH` can also be customised via the IDL Workbench (idlde) Preferences dialog.

- Open the Preferences dialog. 

     * :fontawesome-brands-apple: : Select IDL > Preferences

     * :fontawesome-brands-linux: and :fontawesome-brands-windows: : Select Window > Preferences

- Expand and select on the right pane of the preferences dialog the items, IDL > Paths. 

- Next, on the left side of the dialog, select "IDL path" from the pull down item.

- Next, insert your additional IDL program search paths. 

- If <IDL_DEFAULT>is not already included in your path list, press the "Insert Default" button.  

- Click on Apply and then OK to save your changes.

![logos]
  [logos]: assets/screenshots/idl_path.jpg


  [1]: installation.md
  [2]: https://www.l3harrisgeospatial.com/Support/Self-Help-Tools/Help-Articles/Help-Articles-Detail/ArtMID/10220/ArticleID/16156/Quick-tips-for-customizing-your-IDL-program-search-path
  