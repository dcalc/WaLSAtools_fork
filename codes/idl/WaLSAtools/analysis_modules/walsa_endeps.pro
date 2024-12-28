; -----------------------------------------------------------------------------------------------------
; WaLSAtools: Wave analysis tools
; Copyright (C) 2025 WaLSA Team - Shahin Jafarzadeh et al.
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
; 
; http://www.apache.org/licenses/LICENSE-2.0
; 
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
; 
; Note: If you use WaLSAtools for research, please consider citing:
; Jafarzadeh, S., Jess, D. B., Stangalini, M. et al. 2025, Nature Reviews Methods Primers, in press.
; -----------------------------------------------------------------------------------------------------


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