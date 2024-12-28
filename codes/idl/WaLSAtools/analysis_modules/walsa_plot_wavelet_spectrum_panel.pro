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


pro walsa_plot_wavelet_spectrum_panel, power, period, time, coi, significance, clt=clt, w=w, log=log, removespace=removespace, $
								 koclt=koclt, normal=normal, epsfilename=epsfilename, maxperiod=maxperiod, position=position,ztitle=ztitle

if n_elements(log) eq 0 then log=1
if n_elements(removespace) eq 0 then removespace=0
if n_elements(normal) eq 0 then normal=0
if n_elements(epsfilename) eq 0 then eps = 0 else eps = 1 

eps = 0 

nt = n_elements(reform(time)) & np = n_elements(reform(period))
significance = REBIN(TRANSPOSE(significance),nt,np)

fundf = 1./(time[nt-1]) ; fundamental frequency (frequency resolution) in mHz
if n_elements(maxperiod) eq 0 then maxp = 1./fundf else maxp = maxperiod ; longest period to be plotted
if n_elements(maxperiod) eq 0 then if removespace ne 0 then maxp = max(coi) ; remove areas below the COI
iit = closest_index(maxp,period)
period = period[0:iit]
significance = reform(significance[*,0:iit])
power = reform(power[*,0:iit])

power = reverse(power,2)
significance = reverse(significance,2)

sigi = power/significance

if n_elements(w) eq 0 then w=6

dimensions = GET_SCREEN_SIZE(RESOLUTION=resolution)
xscreensize = dimensions[0]
yscreensize = dimensions[1]
IF (xscreensize le yscreensize) THEN smallest_screensize = xscreensize
IF (yscreensize le xscreensize) THEN smallest_screensize = yscreensize

charsize = 1.75
!x.thick=4.
!y.thick=4.
!x.ticklen=-0.053
!y.ticklen=-0.031
barthick = 300
distbar = 300
coithick = 3.
arrowsize = 20.
arrowthick = 3.5
c_thick = 3.
h_thick = 1.4
; arrowheadsize = 10.

colset
device,decomposed=0

xtitle = 'Time (s)'
; ztitle = 'Power!C'
; if log ne 0 then ztitle = 'Log!d10!n(Power)!C'
if normal ne 0 then begin
    ztitle = 'Normalised Power!C'
    if log ne 0 then ztitle = 'Log!d10!n(Normalised Power)!C'
endif

ii = where(power lt 0., cii)
if cii gt 0 then power(ii) = 0.
if normal ne 0 then power = 100.*power/max(power)

xrg = [min(time),max(time)]
yrg = [max(period),min(period)]

if n_elements(clt) eq 0 then clt=20
loadct, clt
if n_elements(koclt) ne 0 then walsa_powercolor, koclt

if log ne 0 then power = alog10(power)

walsa_image_plot, power, xrange=xrg, yrange=yrg, $
          nobar=0, zrange=minmax(power,/nan), /ylog, $
          contour=0, /nocolor, charsize=charsize, $
          ztitle=ztitle, xtitle=xtitle,  $
          exact=1, aspect=0, cutaspect=0, ystyle=5, $
          barpos=1, zlen=-0.6, distbar=distbar, $ 
          barthick=barthick, position=position

cgAxis, YAxis=0, YRange=yrg, ystyle=1, /ylog, title='Period (s)', charsize=charsize
cgAxis, YAxis=1, YRange=[1./yrg[0],1./yrg[1]], ystyle=1, /ylog, title='Frequency (Hz)', charsize=charsize

; plot the Cone-of-Influence
plots, time, coi, noclip=0, linestyle=0, thick=coithick, color=cgColor('Black')
; shade the area above the Cone-of-Influence, with hashed lines:
ncoi = n_elements(coi)
y = fltarr(ncoi)
for j=0, ncoi-1 do y(j) = maxp
walsa_curvefill, time, y, coi, color = cgColor('Black'), thick=h_thick, /LINE_FILL, ORIENTATION=45 
walsa_curvefill, time, y, coi, color = cgColor('Black'), thick=h_thick, /LINE_FILL, ORIENTATION=-45

; contours mark significance level
cgContour, sigi, /noerase, levels=1., XTICKFORMAT="(A1)", YTICKFORMAT="(A1)", $
    xthick=1.e-40, ythick=1.e-40, xticklen=1.e-40, yticklen=1.e-40, xticks=1.e-40, yticks=1.e-40, $
    c_colors=[cgColor('Navy')], label=0, $
    c_linestyle=0, c_thick=c_thick

end