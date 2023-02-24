;+
; NAME:     endeps
;
; PURPOSE:  End the EPS tool process, started with walsa_eps.pro
;           Save plots above this ending command to filename.eps or filename.pdf
;
; KEYWORDS:
; FILENAME:      Directory and name of the file to be outputted (format: string)
;                Default: fig in the same directory as the code is running.
; NOBOUNDINGBOX: If set, the white areas around the figure are not removed (they are removed by default)
; PDF:           If set, the output format will be a PDF file -- default option
; EPS:           If set, the output format will be an EPS file
;
;  Created by Shahin Jafarzadeh
;-
pro walsa_endeps, filename=filename, noboundingbox=noboundingbox, pdf=pdf, eps=eps
    
    if keyword_set(eps) eq 0 then pdf=1 else eps=1
    if keyword_set(pdf) ne 0 then pdf=1
    if keyword_set(pdf) eq 0 then pdf=0
    if keyword_set(filename) eq 0 then filename='fig'
    if not keyword_set(noboundingbox) then noboundingbox=0
    
    psset,/close
    psset_closeviewer
    filedir = file_which('walsa_endeps.pro')
    slen = strlen(filedir)
    currentdir = strmid(filedir, 0, slen-16)
    spawn, 'chmod 777 ./fig_out.eps'
    
    if file_test(filename+'.eps') then spawn, 'rm -rf '+filename+'.eps'
    if file_test(filename+'.pdf') then spawn, 'rm -rf '+filename+'.pdf'
    
    if noboundingbox eq 0 then begin
        spawn, 'uname -s', currentos
        if currentos eq 'Linux' then epstooldir = currentdir+'epstool-3.08-Linux/'
        if currentos eq 'Darwin' or currentos eq 'Mac' then epstooldir = currentdir+'epstool-3.08-Mac/'
        spawn, 'chmod -R a+x '+epstooldir
        spawn, epstooldir+'bin/epstool --copy --bbox ./fig_out.eps'+' '+filename+'.eps'
        if file_test(filename+'.eps') then spawn, 'rm -rf ./fig_out.eps' else spawn, 'mv ./fig_out.eps '+filename+'.eps'
    endif else spawn, 'mv ./fig_out.eps '+filename+'.eps'
    
    if pdf eq 1 then begin
        epstopdfdir = strmid(filedir, 0, slen-16)
        spawn, 'chmod a+x '+epstopdfdir+'epstopdf'
        spawn, epstopdfdir+'epstopdf '+filename+'.eps'
        spawn, 'rm '+filename+'.eps'
    endif
    
    PRINT
    if pdf eq 1 then print, 'Created PDF file: '+filename+'.pdf' else print, 'Created EPS file: '+filename+'.eps'
    PRINT
    
end