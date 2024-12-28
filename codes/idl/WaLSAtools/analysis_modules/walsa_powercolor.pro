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


pro walsa_powercolor, number

filedir = file_which('walsa_powercolor.pro')
slen = strlen(filedir)
prodir = strmid(filedir, 0, slen-20)

if number eq 1 then userlct,/full,verbose=0,coltab=nnn 
if number eq 2 then begin
	customclt = walsa_readtext(prodir+'color_tables/customct2.txt')
	R = ((reform(customclt[0,*]))/max(reform(customclt[0,*])))*255
	G = ((reform(customclt[1,*]))/max(reform(customclt[1,*])))*255
	B = ((reform(customclt[2,*]))/max(reform(customclt[2,*])))*255
	tvlct, R, G, B
endif
if number eq 3 then begin
	customclt = walsa_readtext(prodir+'color_tables/customct3.txt')
	R = ((reform(customclt[0,*]))/max(reform(customclt[0,*])))*255
	G = ((reform(customclt[1,*]))/max(reform(customclt[1,*])))*255
	B = ((reform(customclt[2,*]))/max(reform(customclt[2,*])))*255

	colnum = n_elements(R)
	colors = fltarr(3,colnum)

	colors[0,*] = R
	colors[1,*] = G
	colors[2,*] = B
	
	ctb0 = COLORTABLE(colors, NCOLORS=colnum)
	ctb = CONGRID(ctb0, 256, 3)

	R = reform(ctb[*,0])
	G = reform(ctb[*,1])
	B = reform(ctb[*,2])
	
	tvlct, R, G, B
endif

end