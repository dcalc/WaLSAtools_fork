; -----------------------------------------------------------------------------
; setup.pro: A script to permanently add WaLSAtools to the IDL library path 
; for Windows, macOS, or Linux.
; -----------------------------------------------------------------------------
; pro setup
  compile_opt idl2

  ; Dynamically determine the current directory using SPAWN
  current_directory = ''
  oslist = ['ultrix']  ; Extend oslist (vector) if required
  if (is_member(!version.os, oslist) AND since_version('4.0.1')) THEN BEGIN
    spawn, 'pwd', /NOSHELL, current_directory
  ENDIF ELSE BEGIN
    cd, CURRENT=current_directory
  ENDELSE

  ; Ensure current_directory is a scalar string
  if size(current_directory, /N_ELEMENTS) NE 1 THEN BEGIN
	  PRINT
	  PRINT, '  Error: Unable to determine the current working directory.'
	  PRINT
	  STOP
  ENDIF

  ; Define the WaLSAtools path based on the current directory
  WaLSAtools_path = STRTRIM(current_directory[0]) + '/WaLSAtools'

  ; Verify if the determined path is valid
  if WaLSAtools_path EQ '' THEN BEGIN
	  PRINT
	  PRINT, '  Error: Unable to determine the WaLSAtools directory.'
	  PRINT
	  STOP
  ENDIF

  ; Get the current IDL path
  current_path = !PATH

  ; Check if WaLSAtools is already in the IDL path
  if STRPOS(current_path, WaLSAtools_path) NE -1 THEN BEGIN
	  PRINT
	  PRINT, '  WaLSAtools is already in the IDL path.'
	  PRINT
	  STOP
  ENDIF

  ; Add WaLSAtools to the IDL path
  new_path = WaLSAtools_path + ':' + current_path
  !PATH = new_path

  ; Detect the operating system
  os_name = STRLOWCASE(GETENV('OS'))  ; Common on Windows
  if os_name EQ '' THEN os_name = STRLOWCASE(GETENV('OSTYPE'))  ; Common on Unix-like systems
  if os_name EQ '' THEN os_name = STRLOWCASE(GETENV('UNAME'))  ; Fallback for other environments

  ; Determine the appropriate resource file based on the OS
  if STRPOS(os_name, 'win') NE -1 THEN BEGIN
    resource_file = GETENV('USERPROFILE') + '\idlrc'
  ENDIF ELSE IF STRPOS(os_name, 'darwin') NE -1 THEN BEGIN
    resource_file = GETENV('HOME') + '/.idlrc'
  ENDIF ELSE IF STRPOS(os_name, 'linux') NE -1 THEN BEGIN
    resource_file = GETENV('HOME') + '/.idlrc'
  ENDIF ELSE BEGIN
	  PRINT
	  PRINT, '  Unsupported operating system. Please manually add WaLSAtools to your IDL path.'
	  PRINT
	  STOP
  ENDELSE

  ; Save the updated path to the resource file
  openw, unit, resource_file, /APPEND
  printf, unit, '!PATH = "' + new_path + '"'
  close, unit

  PRINT
  PRINT, '  WaLSAtools has been added to the IDL path and saved in the resource file.'
  PRINT, '  Restart IDL to apply the changes.'
  PRINT
  STOP
END