;+
; NAME:     endeps
;
; PURPOSE:  End the EPS tool process, started with eps.pro
;           Save plots above this ending command to figt.eps in Desktop (on a MacBook)
;
; KEYWORDS:
; FILENAME: Directory and name of the file to be outputted (format: string)
;			Default: fig.eps in the same directory as the code is running.
;			NOTE: MUST be the same for walsa_endeps! 
;
;  Created by Shahin Jafarzadeh
;-
pro walsa_endeps, filename=filename

    if keyword_set(filename) eq 0 then filename='fig'
    psset,/close
    psset_closeviewer
    filedir = file_which('walsa_endeps.pro')
    slen = strlen(filedir)
    epstooldir = strmid(filedir, 0, slen-16)
    spawn, 'chmod 777 ~/fig_out.eps'
    spawn, epstooldir+'epstool-3.08/bin/epstool --copy --bbox ~/fig_out.eps'+' '+filename+'.eps'
    spawn, 'rm -rf ~/fig_out.eps'
    
    !P.Multi = 0
    
end