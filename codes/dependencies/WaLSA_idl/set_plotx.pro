;sets to 'X' or 'win' according to OS
pro set_plotx
  
  case strlowcase(!version.os_family) of
    'unix': set_plot,'X'
    'windows': set_plot,'WIN'
    else: message,'Unsupported OS: '+!version.os
  endcase
end
