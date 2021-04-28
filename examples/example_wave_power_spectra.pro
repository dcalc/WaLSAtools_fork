; pro example_wave_power_spectra

eps = 1 ; if set, plots are outputted as an eps file, otherwise are shown in a window

data_dir = 'sample_data/'

data = readfits(data_dir+'sdo_aia1700.fits', /silent)
signal = reform(data[10,10,*])
cadence = 12. ; sec
arcsecpx = 0.6 ; arcsec

nt = n_elements(data[0,0,*])

time = findgen(nt)*cadence

fundf = 1000./(time[nt-1]) ; fundamental frequency (frequency resolution) in mHz

colset
device, decomposed=0
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if not eps then begin
    window, 0, xs=1500, ys=800
    charsize = 3.3
    barthick = 15
    distbar = 15
endif else begin
    walsa_eps, size=[30,16]
    !p.font=0
    device,set_font='Times-Roman'
    charsize = 2.0
    barthick = 260
    distbar = 260
endelse

!P.Multi = [0, 3, 3]

!x.thick=1.6
!y.thick=1.6

; range of frequency (in mHz), for plotting. 
; if limit=0, it the power spectra are plotted for the full frequency range
limit = 1
limn = 0.8
xr=[0.8,10]

pos = cgLayout([3,3], OXMargin=[10,4], OYMargin=[7,5], XGap=10, YGap=11)
; --------------------------------------------------------------------------------  
; Wavelet power spectrum: Morlet
WaLSAtools, /wavelet, data=signal, time=time, power=ipower, frequencies=frequencies, significance=isig, mother='Morlet', mode=1, coi=icoi

iperiod = 1000./reform(frequencies) ; period in sec
nt = n_elements(reform(ipower[*,0])) ; number of data points in time
nf = n_elements(reform(iperiod)) ; number of data points in frequency
itime = findgen(nt)*cadence
isig = REBIN(TRANSPOSE(isig),nt,nf)
maxp = max(icoi)
maxp = 1000./fundf
iit = closest_index(maxp,iperiod)
iperiod = iperiod[0:iit]
isig = reform(isig[*,0:iit])
ipower = reform(ipower[*,0:iit])
ipower = reverse(ipower,2)
isig = reverse(isig,2)
sigi = ipower/isig
ii = where(ipower lt 0., cii) & if cii gt 0 then ipower(ii) = 0. & ipower = 100.*ipower/max(ipower)
xrg = minmax(itime) & yrg = [max(iperiod),min(iperiod)]
loadct, 20
walsa_image_plot, ipower, xrange=xrg, yrange=yrg, nobar=0, zrange=minmax(ipower,/nan), /ylog, /revx2ticks, $ ;
          contour=0, /nocolor, yaxyy=8, ztitle='(a) Power (Morlet Wavelet)!C', xtitle='Time (s)', $
          exact=1, aspect=0, cutaspect=0, barpos=1, zlen=-0.45, distbar=barthick, xticklen=-0.04, yticklen=-0.03, xxlen=-0.04, $
          barthick=barthick, charsize=charsize, position= [0.063666670, 0.588499991, 0.287, 0.91833335], ystyle=5

cgAxis, YAxis=0, YRange=yrg, ystyle=1, /ylog, title='Period (s)', charsize=charsize, yticklen=-0.03
cgAxis, YAxis=1, YRange=[1000./yrg[0],1000./yrg[1]], ystyle=1, /ylog, title='Frequency (mHz)', charsize=charsize, yticklen=-0.03

plots, itime, icoi, noclip=0, linestyle=0, thick=2, color=cgColor('Black')
ncoi = n_elements(icoi) & y = fltarr(ncoi) & for j=0, ncoi-1 do y(j) = maxp
sjcurvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=45
sjcurvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=-45
cgContour, sigi, /noerase, levels=1.01, XTICKFORMAT="(A1)", YTICKFORMAT="(A1)", $
     xthick=1.e-40, ythick=1.e-40, xticklen=1.e-40, yticklen=1.e-40, xticks=1.e-40, yticks=1.e-40, $
     c_colors=[cgColor('Navy')], label=0, $
     c_linestyle=0, c_thick=1
; --------------------------------------------------------------------------------
; Wavelet power spectrum: DOG
WaLSAtools, /wavelet, data=signal, time=time, power=ipower, frequencies=frequencies, significance=isig ,mother='DOG', mode=1, coi=icoi

iperiod = 1000./reform(frequencies)
nt = n_elements(reform(ipower[*,0])) & nf = n_elements(reform(iperiod))
itime = findgen(nt)*cadence
isig = REBIN(TRANSPOSE(isig),nt,nf)
maxp = max(icoi)
maxp = 1000./fundf
iit = closest_index(maxp,iperiod)
iperiod = iperiod[0:iit]
isig = reform(isig[*,0:iit])
ipower = reform(ipower[*,0:iit])
ipower = reverse(ipower,2)
isig = reverse(isig,2)
sigi = ipower/isig
ii = where(ipower lt 0., cii) & if cii gt 0 then ipower(ii) = 0. & ipower = 100.*ipower/max(ipower)
xrg = minmax(itime) & yrg = [max(iperiod),min(iperiod)]
loadct, 20
walsa_image_plot, ipower, xrange=xrg, yrange=yrg, nobar=0, zrange=minmax(ipower,/nan), /ylog, /revx2ticks, $ ;
          contour=0, /nocolor, yaxyy=8, ztitle='(b) Power (Mexican-Hat Wavelet)!C', xtitle='Time (s)', $
          exact=1, aspect=0, cutaspect=0, barpos=1, zlen=-0.45, distbar=barthick, xticklen=-0.04, yticklen=-0.03, xxlen=-0.04, $
          barthick=barthick, charsize=charsize, position= [0.063666670, 0.087499991, 0.287, 0.40833335], ystyle=5

cgAxis, YAxis=0, YRange=yrg, ystyle=1, /ylog, title='Period (s)', charsize=charsize, yticklen=-0.03
cgAxis, YAxis=1, YRange=[1000./yrg[0],1000./yrg[1]], ystyle=1, /ylog, title='Frequency (mHz)', charsize=charsize, yticklen=-0.03

plots, itime, icoi, noclip=0, linestyle=0, thick=2, color=cgColor('Black')
ncoi = n_elements(icoi) & y = fltarr(ncoi) & for j=0, ncoi-1 do y(j) = maxp
sjcurvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=45
sjcurvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=-45
cgContour, sigi, /noerase, levels=1.01, XTICKFORMAT="(A1)", YTICKFORMAT="(A1)", $
     xthick=1.e-40, ythick=1.e-40, xticklen=1.e-40, yticklen=1.e-40, xticks=1.e-40, yticks=1.e-40, $
     c_colors=[cgColor('Navy')], label=0, $
     c_linestyle=0, c_thick=1
; --------------------------------------------------------------------------------
cgColorFill, [0.345, 1., 1., 0.345], [0, 0, 1, 1], /NORMAL, COLOR='WT2'
; --------------------------------------------------------------------------------
acube = (reform(walsa_apodcube(signal))+mean(signal))/100
title='(c) Time series'
cgplot, time, acube, Thick=2, Color=cgColor('DodgerBlue'), xtitle='Time (s)', charsize=charsize, xticklen=-0.06, pos=pos[*,1], $
    xs=1, yr=[min(reform(acube))-1.50, max(reform(acube))+1.50], /NOERASE, ytitle='DN (arb. unit)'

xyouts, min(time)+((max(time)-min(time))/2.), max(reform(acube))+1.50+1.30, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
note = 'linearly detrended & apodized with Tukey window'
xyouts, min(time)+((max(time)-min(time))/2.), max(reform(acube))+0.2, ALIGNMENT=0.5, CHARSIZE=charsize/2.55, /data, note, color=cgColor('Black')
; --------------------------------------------------------------------------------
; FFT power spectrum
WaLSAtools, /fft, data=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, nperm=5000

if limit then pm1 = pm[where(frequencies ge limn and frequencies le 10)] 
pm = 100.*pm/max(pm1)
title='(f) FFT'
cgplot, frequencies, pm, yr=[0,119], XTICKINTERVAL=1, xr=xr, xminor=4, charsize=charsize, xticklen=-0.06, pos=pos[*,2], /NOERASE, $
    YTICKINTERVAL=30, xtitle='Frequency (mHz)', ytitle='Power'
cgColorFill, [3.0303030,3.7037036,3.7037036,3.0303030], [0,0,105.,105.], Color='Papaya' ; 5-min band
cgColorFill, [4.7619047,6.6666665,6.6666665,4.7619047], [0,0,105.,105.], Color='Lavender' ; 3-min band
sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
oplot, frequencies, pm, Thick=2, Color=cgColor('Red')
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Black'), linest=3, Thick=2
sjhline, 105, color=cgColor('Black')
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')

loc=[8.9,90]
cgPlots, [loc[0],loc[0]+0.75], [loc[1],loc[1]], linestyle=3, color=cgColor('Black'), thick=2, /data
xyouts, loc[0]-0.2, loc[1]-3.0, '95% confidence level', ALIGNMENT=1, CHARSIZE=charsize/2.5, /data, color=cgColor('Black')
; --------------------------------------------------------------------------------
; Global Wavelet power spectrum: Morlet (m=6)
WaLSAtools, /wavelet, data=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /global, nperm=5000

if limit then pm1 = pm[where(frequencies ge limn and frequencies le 10)]
pm = 100.*pm/max(pm1)
title='(d) Global Wavelet'
cgplot, frequencies, pm, yr=[0,119], XTICKINTERVAL=1, xr=xr, xminor=4, charsize=charsize, xticklen=-0.06, pos=pos[*,4], $
    /NOERASE, YTICKINTERVAL=30, xtitle='Frequency (mHz)', ytitle='Power'
cgColorFill, [3.0303030,3.7037036,3.7037036,3.0303030], [0,0,105.,105.], Color='Papaya' ; 5-min band
cgColorFill, [4.7619047,6.6666665,6.6666665,4.7619047], [0,0,105.,105.], Color='Lavender' ; 3-min band
sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
oplot, frequencies, pm, Thick=2, Color=cgColor('Red')
sjhline, 105, color=cgColor('Black')
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Black'), linest=3, Thick=2

; Global Wavelet power spectrum: DOG (the real-valued Mexican hat wavelet; m=2)
WaLSAtools, /wavelet, data=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /global, nperm=5000, mother='DOG'

if limit then pm1 = pm[where(frequencies ge limn and frequencies le 10)]
pm = 100.*pm/max(pm1)
oplot, frequencies, pm, Thick=2, Color=cgColor('DarkGreen'), linestyle=2
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Blue'), linest=4, Thick=2

; legends
loc=[8.9,90] & VSpace=19 & ls = [0,2] & colors=['Red','DarkGreen'] & names = ['Morlet','Mexican Hat']
for fac=0L, 1 do begin
    cgPlots, [loc[0],loc[0]+0.73], [loc[1]-fac*VSpace,loc[1]-fac*VSpace], linestyle=ls[fac], color=cgColor(colors[fac]), thick=2, /data
    xyouts, loc[0]-0.2, loc[1]-fac*VSpace-3.0, names[fac], ALIGNMENT=1, CHARSIZE=charsize/2.5, /data, color=cgColor('Black')
endfor
; --------------------------------------------------------------------------------
; Lomb-scargle power spectrum: suitable for unevenly sampled data.
WaLSAtools, /lomb, data=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, nperm=5000

if limit then pm1 = pm[where(frequencies ge limn and frequencies le 10)]
pm = 100.*pm/max(pm1)
title='(g) Lomb-Scargle'
cgplot, frequencies, pm, yr=[0,119], XTICKINTERVAL=1, xr=xr, xminor=4, charsize=charsize, xticklen=-0.06, pos=pos[*,5], $
    /NOERASE, YTICKINTERVAL=30, xtitle='Frequency (mHz)', ytitle='Power'
cgColorFill, [3.0303030,3.7037036,3.7037036,3.0303030], [0,0,105.,105.], Color='Papaya' ; 5-min band
cgColorFill, [4.7619047,6.6666665,6.6666665,4.7619047], [0,0,105.,105.], Color='Lavender' ; 3-min band
sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
oplot, frequencies, pm, Thick=2, Color=cgColor('Red')
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Black'), linest=3, Thick=2
sjhline, 105, color=cgColor('Black')
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
; --------------------------------------------------------------------------------
; Global Wavelet power spectrum inside COI: Morlet m=6
WaLSAtools, /wavelet, data=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /insideCOI, nperm=5000

if limit then pm1 = pm[where(frequencies ge limn and frequencies le 10)]
pm = 100.*pm/max(pm1)
title='(e) Global Wavelet (inside COI)'
cgplot, frequencies, pm, yr=[0,119], XTICKINTERVAL=1, xr=xr, xminor=4, charsize=charsize, xticklen=-0.06, pos=pos[*,7], $
    /NOERASE, YTICKINTERVAL=30, xtitle='Frequency (mHz)', ytitle='Power'
cgColorFill, [3.0303030,3.7037036,3.7037036,3.0303030], [0,0,105.,105.], Color='Papaya' ; 5-min band
cgColorFill, [4.7619047,6.6666665,6.6666665,4.7619047], [0,0,105.,105.], Color='Lavender' ; 3-min band
sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
oplot, frequencies, pm, Thick=2, Color=cgColor('Red')
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Black'), linest=3, Thick=2
sjhline, 105, color=cgColor('Black')
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')

; Global Wavelet power spectrum inside COI: DOG m=2 (Mexican hat)
WaLSAtools, /wavelet, data=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /insideCOI, nperm=5000, mother='DOG'

if limit then pm1 = pm[where(frequencies ge limn and frequencies le 10)]
pm = 100.*pm/max(pm1)
oplot, frequencies, pm, Thick=2, Color=cgColor('DarkGreen'), linestyle=2
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Blue'), linest=4, Thick=2
; --------------------------------------------------------------------------------
; HHT power spectrum
WaLSAtools, /hht, data=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /nosignificance, stdlimit=0.05

if limit then pm1 = pm[where(frequencies ge limn and frequencies le 10)]
pm = 100.*pm/max(pm1)
title='(h) HHT (EMD + Hilbert)'
cgplot, frequencies, pm, yr=[0,119], xtitle='Frequency (mHz)', ytitle='Power', XTICKINTERVAL=1, xr=xr, xminor=4, charsize=charsize, $
    xticklen=-0.06, pos=pos[*,8], /NOERASE, YTICKINTERVAL=30
cgColorFill, [3.0303030,3.7037036,3.7037036,3.0303030], [0,0,105.,105.], Color='Papaya' ; 5-min band
cgColorFill, [4.7619047,6.6666665,6.6666665,4.7619047], [0,0,105.,105.], Color='Lavender' ; 3-min band
sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
oplot, frequencies, pm, Thick=2, Color=cgColor('Red')

sjhline, 105, color=cgColor('Black')
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
; --------------------------------------------------------------------------------

if eps then walsa_endeps, filename='sample_data/example_power_spectra'

!P.Multi = 0
Cleanplot, /Silent

PRINT

end