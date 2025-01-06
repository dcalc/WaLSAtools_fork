; pro FIG3__walsatools_power_spectra

data_dir= 'Synthetic_Data/'

signal = readfits(data_dir+'NRMP_signal_1D.fits')
time = readfits(data_dir+'NRMP_signal_1D.fits', ext=1)

sf = [2, 5, 10, 12, 15, 18, 25, 33] ; input frequencies

nt = n_elements(time)
fundf = 1./(time[nt-1]) ; fundamental frequency (frequency resolution) in mHz

colset
device, decomposed=0

walsa_eps, size=[30,28]
!p.font=0
device,set_font='helvetica'
charsize = 2.3
barthick = 300
distbar = 300

; Create uneven sampling
n_points = n_elements(reform(signal))
; Define gaps to be removed
gap1_size = 17
gap2_size = 42
gap3_size = 95
gap4_size = 46
gaps_size =[gap1_size,gap2_size,gap3_size,gap4_size]*0.01
; Define start indices for each gap (for example)
gap1_start = 150
gap2_start = 200
gap3_start = 500
gap4_start = 800
gaps_start = [gap1_start,gap2_start,gap3_start,gap4_start]*0.01
; Remove gaps
indices = LINDGEN(n_points) ; Initial set of indices
indices = indices[WHERE(indices LT gap1_start OR indices GE gap1_start + gap1_size)]
indices = indices[WHERE(indices LT gap2_start OR indices GE gap2_start + gap2_size)]
indices = indices[WHERE(indices LT gap3_start OR indices GE gap3_start + gap3_size)]
indices = indices[WHERE(indices LT gap4_start OR indices GE gap4_start + gap4_size)]
; Reduce both time and signal arrays according to final indices
t_uneven = time[indices]
signal_uneven = signal[indices]

t_uneven = t_uneven(sort(t_uneven))
signal_uneven = signal_uneven(sort(t_uneven))

!P.Multi = [0, 3, 5]

!x.thick=4.0
!y.thick=4.0

; define range of frequency (in mHz), for plotting.
limit = 0

xr = [0,36]

poswave1 = [0.74077778, 0.787, 0.94666664, 0.937]
poswave2 = [0.74077778, 0.524, 0.94666664, 0.674]
poswave3 = [0.7407778, 0.26, 0.94666664, 0.41]

pos = cgLayout([3,5], OXMargin=[10,4], OYMargin=[7,5], XGap=10, YGap=11)
; --------------------------------------------------------------------------------
; Wavelet power spectrum: Morlet
WaLSAtools, /wavelet, signal=signal, time=time, power=ipower, frequencies=frequencies, significance=isig, mother='Morlet', mode=1, coi=icoi
frequencies = frequencies/1000.

iperiod = 1./reform(frequencies) ; period in sec
nt = n_elements(reform(ipower[*,0])) ; number of data points in time
nf = n_elements(reform(iperiod)) ; number of data points in frequency
itime = time
isig = REBIN(TRANSPOSE(isig),nt,nf)
maxp = max(icoi)
; maxp = 1./fundf
iit = closest_index(maxp,iperiod)
iperiod = iperiod[0:iit]
isig = reform(isig[*,0:iit])
ipower = reform(ipower[*,0:iit])
ipower = reverse(ipower,2)
isig = reverse(isig,2)
sigi = ipower/isig
ii = where(ipower lt 0., cii) & if cii gt 0 then ipower(ii) = 0. & ipower = 100.*ipower/max(ipower)
xrg = minmax(itime)
; yrg = [10.,0.025]
yrg = [max(iperiod),min(iperiod)]

; Load color table 20 and enhance it for better visibility
LOADCT, 20, /SILENT
TVLCT, r, g, b, /GET
r = BYTSCL(r, MIN=90, MAX=255)
g = BYTSCL(g, MIN=90, MAX=255)
b = BYTSCL(b, MIN=90, MAX=255)
TVLCT, r, g, b

walsa_image_plot, ipower, xrange=xrg, yrange=yrg, nobar=0, zrange=minmax(ipower,/nan), /ylog, $
          contour=0, /nocolor, xtitle='Time (s)', $
          exact=1, aspect=0, cutaspect=0, barpos=1, zlen=-0.75, distbar=barthick, xticklen=-0.06, yticklen=-0.045, xxlen=-0.04, $
          barthick=barthick, charsize=charsize, position= poswave1, ystyle=5, cbfac=0.9

ztitle='(l) Power (%) | Morlet Wavelet'
xyouts, poswave1[0]+((poswave1[2]-poswave1[0])/2.), poswave1[3]+0.028, ALIGNMENT=0.5, CHARSIZE=charsize/2., /normal, ztitle, color=cgColor('Black')

sjhline, 1./sf, color=cgColor('Green')

cgAxis, YAxis=0, YRange=yrg, ystyle=1, /ylog, title='Period (s)', charsize=charsize, yticklen=-0.03
cgAxis, YAxis=1, YRange=[1./yrg[0],1./yrg[1]], ystyle=1, /ylog, title='Frequency (Hz)', charsize=charsize, yticklen=-0.03

plots, itime, icoi, noclip=0, linestyle=0, thick=2, color=cgColor('Black')
ncoi = n_elements(icoi) & y = fltarr(ncoi) & for j=0, ncoi-1 do y(j) = maxp
walsa_curvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=45
walsa_curvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=-45

cgContour, sigi, /noerase, levels=1.01, XTICKFORMAT="(A1)", YTICKFORMAT="(A1)", $
     xthick=1.e-40, ythick=1.e-40, xticklen=1.e-40, yticklen=1.e-40, xticks=1.e-40, yticks=1.e-40, $
     c_colors=[cgColor('Navy')], label=0, $
     c_linestyle=0, c_thick=1
; --------------------------------------------------------------------------------
; Wavelet power spectrum: DOG
WaLSAtools, /wavelet, signal=signal, time=time, power=ipower, frequencies=frequencies, significance=isig ,mother='DOG', mode=1, coi=icoi
frequencies = frequencies/1000.

iperiod = 1./reform(frequencies)
nt = n_elements(reform(ipower[*,0])) & nf = n_elements(reform(iperiod))
itime = time
isig = REBIN(TRANSPOSE(isig),nt,nf)
maxp = max(icoi)
; maxp = 1./fundf
iit = closest_index(maxp,iperiod)
iperiod = iperiod[0:iit]
isig = reform(isig[*,0:iit])
ipower = reform(ipower[*,0:iit])
ipower = reverse(ipower,2)
isig = reverse(isig,2)
sigi = ipower/isig
ii = where(ipower lt 0., cii) & if cii gt 0 then ipower(ii) = 0. & ipower = 100.*ipower/max(ipower)
xrg = minmax(itime)
yrg = [max(iperiod),min(iperiod)]

; Load color table 20 and enhance it for better visibility
LOADCT, 20, /SILENT
TVLCT, r, g, b, /GET
r = BYTSCL(r, MIN=90, MAX=255)
g = BYTSCL(g, MIN=90, MAX=255)
b = BYTSCL(b, MIN=90, MAX=255)
TVLCT, r, g, b

walsa_image_plot, ipower, xrange=xrg, yrange=yrg, nobar=0, zrange=minmax(ipower,/nan), /ylog, $
          contour=0, /nocolor, xtitle='Time (s)', $
          exact=1, aspect=0, cutaspect=0, barpos=1, zlen=-0.75, distbar=barthick, xticklen=-0.06, yticklen=-0.045, xxlen=-0.04, $
          barthick=barthick, charsize=charsize, position= poswave2, ystyle=5, cbfac=0.9

ztitle='(m) Power (%) | Mexican-Hat Wavelet'
xyouts, poswave2[0]+((poswave2[2]-poswave2[0])/2.), poswave2[3]+0.028, ALIGNMENT=0.5, CHARSIZE=charsize/2., /normal, ztitle, color=cgColor('Black')

sjhline, 1./sf, color=cgColor('Green')

cgAxis, YAxis=0, YRange=yrg, ystyle=1, /ylog, title='Period (s)', charsize=charsize, yticklen=-0.03
cgAxis, YAxis=1, YRange=[1./yrg[0],1./yrg[1]], ystyle=1, /ylog, title='Frequency (Hz)', charsize=charsize, yticklen=-0.03

plots, itime, icoi, noclip=0, linestyle=0, thick=2, color=cgColor('Black')
ncoi = n_elements(icoi) & y = fltarr(ncoi) & for j=0, ncoi-1 do y(j) = maxp
walsa_curvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=45
walsa_curvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=-45

cgContour, sigi, /noerase, levels=1.01, XTICKFORMAT="(A1)", YTICKFORMAT="(A1)", $
     xthick=1.e-40, ythick=1.e-40, xticklen=1.e-40, yticklen=1.e-40, xticks=1.e-40, yticks=1.e-40, $
     c_colors=[cgColor('Navy')], label=0, $
     c_linestyle=0, c_thick=1
; --------------------------------------------------------------------------------
; Wavelet power spectrum: Paul
WaLSAtools, /wavelet, signal=signal, time=time, power=ipower, frequencies=frequencies, significance=isig ,mother='Paul', mode=1, coi=icoi

frequencies = frequencies/1000.

iperiod = 1./reform(frequencies)
nt = n_elements(reform(ipower[*,0])) & nf = n_elements(reform(iperiod))
itime = time
isig = REBIN(TRANSPOSE(isig),nt,nf)
maxp = max(icoi)
; maxp = 1./fundf
iit = closest_index(maxp,iperiod)
iperiod = iperiod[0:iit]
isig = reform(isig[*,0:iit])
ipower = reform(ipower[*,0:iit])
ipower = reverse(ipower,2)
isig = reverse(isig,2)
sigi = ipower/isig
ii = where(ipower lt 0., cii) & if cii gt 0 then ipower(ii) = 0. & ipower = 100.*ipower/max(ipower)
xrg = minmax(itime)
yrg = [max(iperiod),min(iperiod)]

; Load color table 20 and enhance it for better visibility
LOADCT, 20, /SILENT
TVLCT, r, g, b, /GET
r = BYTSCL(r, MIN=90, MAX=255)
g = BYTSCL(g, MIN=90, MAX=255)
b = BYTSCL(b, MIN=90, MAX=255)
TVLCT, r, g, b

walsa_image_plot, ipower, xrange=xrg, yrange=yrg, nobar=0, zrange=minmax(ipower,/nan), /ylog, $
          contour=0, /nocolor, xtitle='Time (s)', $
          exact=1, aspect=0, cutaspect=0, barpos=1, zlen=-0.75, distbar=barthick, xticklen=-0.06, yticklen=-0.045, xxlen=-0.04, $
          barthick=barthick, charsize=charsize, position= poswave3, ystyle=5, cbfac=0.9

ztitle='(n) Power (%) | Paul Wavelet'
xyouts, poswave3[0]+((poswave3[2]-poswave3[0])/2.), poswave3[3]+0.028, ALIGNMENT=0.5, CHARSIZE=charsize/2., /normal, ztitle, color=cgColor('Black')

sjhline, 1./sf, color=cgColor('Green')

cgAxis, YAxis=0, YRange=yrg, ystyle=1, /ylog, title='Period (s)', charsize=charsize, yticklen=-0.03
cgAxis, YAxis=1, YRange=[1./yrg[0],1./yrg[1]], ystyle=1, /ylog, title='Frequency (Hz)', charsize=charsize, yticklen=-0.03

plots, itime, icoi, noclip=0, linestyle=0, thick=2, color=cgColor('Black')
ncoi = n_elements(icoi) & y = fltarr(ncoi) & for j=0, ncoi-1 do y(j) = maxp
walsa_curvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=45
walsa_curvefill, itime, y, icoi, color = cgColor('Black'), thick=1, /LINE_FILL, ORIENTATION=-45

cgContour, sigi, /noerase, levels=1.01, XTICKFORMAT="(A1)", YTICKFORMAT="(A1)", $
     xthick=1.e-40, ythick=1.e-40, xticklen=1.e-40, yticklen=1.e-40, xticks=1.e-40, yticks=1.e-40, $
     c_colors=[cgColor('Navy')], label=0, $
     c_linestyle=0, c_thick=1

; --------------------------------------------------------------------------------
cgColorFill, [0.025, 0.663, 0.663, 0.025], [0, 0, 1, 1], /NORMAL, COLOR='LightGray' ; COLOR='WT2'
cgColorFill, [0.66, 1.01, 1.01, 0.66], [0, 0, 0.20, 0.20], /NORMAL, COLOR='LightGray'
; --------------------------------------------------------------------------------
; Plot the detrended & apodized light curve
acube = (reform(walsa_detrend_apod(signal))+mean(signal))
title='(c) Time series'
cgplot, time, acube*10., Thick=2, Color=cgColor('DodgerBlue'), xtitle='Time (s)', charsize=charsize, xticklen=-0.09, yticklen=-0.03, pos=pos[*,0], $
    xs=1, yr=[min(reform(acube*10.)), max(reform(acube*10.))], /NOERASE, ytitle='DN (arb. unit)', YTICKINTERVAL=40

; xyouts, min(time)+((max(time)-min(time))/2.), max(reform(acube)), ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
note = '(a) Detrended & apodized synthetic signal'
xyouts, min(time)+((max(time)-min(time))/2.), max(reform(acube*10.))+12.3, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, note, color=cgColor('Black')
; xyouts, min(time)+((max(time)-min(time))/2.), max(reform(acube*10.))+10.3, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, 'f (Hz)= '+stitle, color=cgColor('Black')
; --------------------------------------------------------------------------------
; Plot the detrended & apodized light curve + gaps (missing data points)
acube = (reform(walsa_detrend_apod(signal))+mean(signal))
title='(c) Time series'
cgplot, time, acube*10., Thick=2, Color=cgColor('DodgerBlue'), xtitle='Time (s)', charsize=charsize, xticklen=-0.09, yticklen=-0.03, pos=pos[*,3], $
    xs=1, yr=[min(reform(acube*10.)), max(reform(acube*10.))], /NOERASE, ytitle='DN (arb. unit)', YTICKINTERVAL=40

; gaps: the unevenly sampled data
for igaps=0L, 3 do $
	cgColorFill, [gaps_start[igaps],gaps_start[igaps]+gaps_size[igaps],gaps_start[igaps]+gaps_size[igaps],gaps_start[igaps]], $
	 [min(reform(acube*10.)),min(reform(acube*10.)),max(reform(acube*10.))-2,max(reform(acube*10.))-2], Color='LightGray'

; xyouts, min(time)+((max(time)-min(time))/2.), max(reform(acube)), ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
note = '(b) The synthetic signal with gaps'
xyouts, min(time)+((max(time)-min(time))/2.), max(reform(acube*10.))+12.3, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, note, color=cgColor('Black')
; --------------------------------------------------------------------------------
; FFT power spectrum
WaLSAtools, /fft, signal=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, nperm=1000

frequencies = frequencies/1000.
pm1 = pm
pm = 100.*pm/max(pm1)
title='(c) FFT'
cgplot, frequencies, pm, yr=[0,12], XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, xticklen=-0.09, yticklen=-0.03, pos=pos[*,1], /NOERASE, $
    YTICKINTERVAL=5, xtitle='Frequency (Hz)', ytitle='Power (%)'

; sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
sjvline, sf, color=cgColor('Green')
oplot, frequencies, pm, Thick=2, Color=cgColor('Red')
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Black'), linest=3, Thick=2
sjhline, 10.5, color=cgColor('Black')
sjvline, frequencies, color=cgColor('Navy'), yrange=[10.5,12]
xyouts, xr[0]+((xr[1]-xr[0])/2.), 13.5, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')

loc=[32,11]
cgPlots, [loc[0],loc[0]+4], [loc[1]-2.,loc[1]-2.], linestyle=3, color=cgColor('Black'), thick=2, /data
xyouts, loc[0]-0.2, loc[1]-2.5, '95% confidence level', ALIGNMENT=1, CHARSIZE=charsize/2.5, /data, color=cgColor('Black')
; --------------------------------------------------------------------------------
; Global Wavelet Spectrum: Morlet (k0=6)
WaLSAtools, /wavelet, signal=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /global, nperm=1000, mother='Morlet'
frequencies = frequencies/1000.
pm1 = pm
pm = 100.*pm/max(pm1)
title='(e) GWS'
cgplot, frequencies, pm, yr=[0,119], XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, xticklen=-0.09, yticklen=-0.03, pos=pos[*,6], $
    /NOERASE, YTICKINTERVAL=30, xtitle='Frequency (Hz)', ytitle='Power (%)'

sjvline, sf, color=cgColor('Green')
oplot, frequencies, pm, Thick=3, Color=cgColor('DarkGreen')
sjhline, 105, color=cgColor('Black')
sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('DarkGreen'), linest=3, Thick=2
fffff=frequencies
; Global Wavelet power spectrum: Paul (m=4)
WaLSAtools, /wavelet, signal=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /global, nperm=1000, mother='Paul'
frequencies = frequencies/1000.
pm1 = pm
pm = 100.*pm/max(pm1)
oplot, frequencies, pm, Thick=6, Color=cgColor('Blue'), linestyle=0
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Blue'), linest=3, Thick=2

; Global Wavelet power spectrum: DOG (the real-valued Mexican hat wavelet; m=2)
WaLSAtools, /wavelet, signal=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /global, nperm=1000, mother='DOG'
frequencies = frequencies/1000.
pm1 = pm
pm = 100.*pm/max(pm1)
oplot, frequencies, pm, Thick=3, Color=cgColor('Red'), linestyle=0
; oplot, frequencies, pm, Thick=1, Color=cgColor('black'), linestyle=0
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Red'), linest=3, Thick=2
; oplot, frequencies, 100.*significance/max(pm1), color=cgColor('black'), linest=3, Thick=1

; legends
loc=[32,90] & VSpace=19 & ls = [0,0,0] & colors=['DarkGreen','Red','Blue'] & names = ['Morlet','Mexican Hat','Paul']
for fac=0L, 2 do begin
    cgPlots, [loc[0],loc[0]+2.5], [loc[1]-fac*VSpace,loc[1]-fac*VSpace], linestyle=ls[fac], color=cgColor(colors[fac]), thick=3, /data
    xyouts, loc[0]-0.4, loc[1]-fac*VSpace-3.0, names[fac], ALIGNMENT=1, CHARSIZE=charsize/2.5, /data, color=cgColor('Black')
endfor
; --------------------------------------------------------------------------------
; Lomb-scargle power spectrum: suitable for unevenly sampled data.
WaLSAtools, /lomb, signal=signal_uneven, time=t_uneven, power=pm, frequencies=frequencies, significance=significance, mode=1, nperm=1000
frequencies = frequencies/1000.
pm1 = pm
pm = 100.*pm/max(pm1)
title='(d) Lomb-Scargle'
cgplot, frequencies, pm, yr=[0,12], XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, xticklen=-0.09, yticklen=-0.03, pos=pos[*,4], $
    /NOERASE, YTICKINTERVAL=5, xtitle='Frequency (Hz)', ytitle='Power (%)'

sjvline, sf, color=cgColor('Green')
oplot, frequencies, pm, Thick=2, Color=cgColor('Red')
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Black'), linest=3, Thick=2
sjhline, 10.5, color=cgColor('Black')
sjvline, frequencies, color=cgColor('Navy'), yrange=[10.5,12]
xyouts, xr[0]+((xr[1]-xr[0])/2.), 13.5, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
; --------------------------------------------------------------------------------
; Refined Global Wavelet Spectrum (power-weighted frequency distribution with significant power & unaffected by CoI): Morlet m=6
WaLSAtools, /wavelet, signal=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /rgws, mother='Morlet'
frequencies = frequencies/1000.
pm1 = pm
pm = 100.*pm/max(pm1)
title='(f) RGWS'
cgplot, frequencies, pm, yr=[0,119], XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, xticklen=-0.09, yticklen=-0.03, pos=pos[*,7], $
    /NOERASE, YTICKINTERVAL=30, xtitle='Frequency (Hz)', ytitle='Power (%)'

sjvline, sf, color=cgColor('Green')
oplot, frequencies, pm, Thick=3, Color=cgColor('DarkGreen')
sjhline, 105, color=cgColor('Black')
sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')

; RGWS: Paul
WaLSAtools, /wavelet, signal=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /rgws, nperm=1000, mother='Paul'
frequencies = frequencies/1000.
pm1 = pm
pm = 100.*pm/max(pm1)
oplot, frequencies, pm, Thick=5, Color=cgColor('Blue'), linestyle=0

; RGWS (power-weighted frequency distribution with significant power & unaffected by CoI): DOG m=2 (Mexican hat)
WaLSAtools, /wavelet, signal=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, /rgws, mother='DOG'
frequencies = frequencies/1000.
pm1 = pm
pm = 100.*pm/max(pm1)
sjvline, sf, color=cgColor('Green')
oplot, frequencies, pm, Thick=3, Color=cgColor('Red'), linestyle=0

; --------------------------------------------------------------------------------
; ; HHT power spectrum
; WaLSAtools, /hht, signal=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, nperm=50, stdlimit=0.05
; frequencies = frequencies/1000.
; pm1 = pm
; pm = 100.*pm/max(pm1)
; title='(e) HHT (EMD + Hilbert)'
; cgplot, frequencies, pm, yr=[0,119], xtitle='Frequency (Hz)', ytitle='Power (%)', XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, $
;     xticklen=-0.09, yticklen=-0.03, pos=pos[*,6], /NOERASE, YTICKINTERVAL=30
;
; sjvline, sf, color=cgColor('Green')
; sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
; oplot, frequencies, pm, Thick=2, Color=cgColor('Red')
; oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Black'), linest=3, Thick=2
; sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
; sjhline, 105, color=cgColor('Black')
; xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
; --------------------------------------------------------------------------------
; HHT - EMD from Python
freq_bins = readfits('Python_parameters/EMD_freq_bins.fits')
power_spectrum = readfits('Python_parameters/EMD_power_spectrum.fits')
significance_level = readfits('Python_parameters/EMD_significance_level.fits')

pm = 100.*power_spectrum/max(power_spectrum)
title='(g) HHT (EMD + Hilbert)'
cgplot, freq_bins, pm, yr=[0,119], xtitle='Frequency (Hz)', ytitle='Power (%)', XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, $
    xticklen=-0.09, yticklen=-0.03, pos=pos[*,9], /NOERASE, YTICKINTERVAL=30

sjvline, sf, color=cgColor('Green')
oplot, freq_bins, pm, Thick=4, Color=cgColor('Red')
oplot, freq_bins, 100.*significance_level/max(power_spectrum), color=cgColor('Black'), linest=3, Thick=4
sjvline, freq_bins, color=cgColor('Navy'), yrange=[105,119]
sjhline, 105, color=cgColor('Black')
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
; --------------------------------------------------------------------------------
; EMD from Python: FFT of IMFs
psd_spectra_fft = readfits('Python_parameters/EMD_psd_spectra_fft.fits')
confidence_levels_fft = readfits('Python_parameters/EMD_confidence_levels_fft.fits')

xf = reform(psd_spectra_fft[*,0,0])

title='(h) FFT of IMFs (EMD)'
cgplot, xf, 100.*reform(psd_spectra_fft[*,1,0])/max(reform(psd_spectra_fft[*,1,0])), yr=[0,12], xtitle='Frequency (Hz)', ytitle='Power (%)', XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, xticklen=-0.09, yticklen=-0.03, pos=pos[*,10], /NOERASE, YTICKINTERVAL=5

icolor = ['DodgerBlue', 'Orange Red', 'DarkGreen', 'Red', 'gray', 'Orchid', 'Lime Green', 'Cyan']

sjvline, sf, color=cgColor('Green')
oplot, xf, 100.*reform(psd_spectra_fft[*,1,0])/max(reform(psd_spectra_fft[*,1,0])), Thick=4, Color=cgColor(icolor(0))
oplot, xf, 100.*reform(confidence_levels_fft[*,0])/max(reform(psd_spectra_fft[*,1,0])), color=cgColor('Black'), linest=3, Thick=3

for ic=1L, 7 do oplot, reform(psd_spectra_fft[*,0,ic]), 100.*reform(psd_spectra_fft[*,1,ic])/max(reform(psd_spectra_fft[*,1,0])), Thick=4, Color=cgColor(icolor(ic))
for ic=1L, 7 do oplot, xf, 100.*reform(confidence_levels_fft[*,ic])/max(reform(psd_spectra_fft[*,1,0])), color=cgColor('Black'), linest=3, Thick=3

sjvline, xf, color=cgColor('Navy'), yrange=[10.5,12]
sjhline, 10.5, color=cgColor('Black')
xyouts, xr[0]+((xr[1]-xr[0])/2.), 13.5, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
; --------------------------------------------------------------------------------
; HHT - EEMD from Python
freq_bins = readfits('Python_parameters/EEMD_freq_bins.fits')
power_spectrum = readfits('Python_parameters/EEMD_power_spectrum.fits')
significance_level = readfits('Python_parameters/EEMD_significance_level.fits')

pm = 100.*power_spectrum/max(power_spectrum)
title='(i) HHT (EEMD + Hilbert)'
cgplot, freq_bins, pm, yr=[0,119], xtitle='Frequency (Hz)', ytitle='Power (%)', XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, $
    xticklen=-0.09, yticklen=-0.03, pos=pos[*,12], /NOERASE, YTICKINTERVAL=30

sjvline, sf, color=cgColor('Green')
oplot, freq_bins, pm, Thick=4, Color=cgColor('Red')
oplot, freq_bins, 100.*significance_level/max(power_spectrum), color=cgColor('Black'), linest=3, Thick=4
sjvline, freq_bins, color=cgColor('Navy'), yrange=[105,119]
sjhline, 105, color=cgColor('Black')
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
; --------------------------------------------------------------------------------
; EEMD from Python: FFT of IMFs
psd_spectra_fft = readfits('Python_parameters/EEMD_psd_spectra_fft.fits')
confidence_levels_fft = readfits('Python_parameters/EEMD_confidence_levels_fft.fits')

xf = reform(psd_spectra_fft[*,0,0])

title='(j) FFT of IMFs (EEMD)'
cgplot, xf, 100.*reform(psd_spectra_fft[*,1,0])/max(reform(psd_spectra_fft[*,1,0])), yr=[0,12], xtitle='Frequency (Hz)', ytitle='Power (%)', XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, xticklen=-0.09, yticklen=-0.03, pos=pos[*,13], /NOERASE, YTICKINTERVAL=5

icolor = ['DodgerBlue', 'Orange Red', 'DarkGreen', 'Red', 'gray', 'Orchid', 'Lime Green', 'Cyan']

sjvline, sf, color=cgColor('Green')
oplot, xf, 100.*reform(psd_spectra_fft[*,1,0])/max(reform(psd_spectra_fft[*,1,0])), Thick=4, Color=cgColor(icolor(0))
oplot, xf, 100.*reform(confidence_levels_fft[*,0])/max(reform(psd_spectra_fft[*,1,0])), color=cgColor('Black'), linest=3, Thick=3

for ic=1L, 7 do oplot, reform(psd_spectra_fft[*,0,ic]), 100.*reform(psd_spectra_fft[*,1,ic])/max(reform(psd_spectra_fft[*,1,0])), Thick=4, Color=cgColor(icolor(ic))
for ic=1L, 7 do oplot, xf, 100.*reform(confidence_levels_fft[*,ic])/max(reform(psd_spectra_fft[*,1,0])), color=cgColor('Black'), linest=3, Thick=3

sjvline, xf, color=cgColor('Navy'), yrange=[10.5,12]
sjhline, 10.5, color=cgColor('Black')
xyouts, xr[0]+((xr[1]-xr[0])/2.), 13.5, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
; --------------------------------------------------------------------------------
; Welch power spectrum
WaLSAtools, /welch, signal=signal, time=time, power=pm, frequencies=frequencies, significance=significance, mode=1, window_size=200., overlap=20.
frequencies = frequencies/1000. ; mHz to Hz
pm1 = pm
pm = 100.*pm/max(pm1)
title='(k) Welch'
cgplot, frequencies, pm, yr=[0,119], xtitle='Frequency (Hz)', ytitle='Power (%)', XTICKINTERVAL=5, xr=xr, xminor=5, charsize=charsize, $
    xticklen=-0.09, yticklen=-0.03, pos=pos[*,14], /NOERASE, YTICKINTERVAL=30

sjvline, sf, color=cgColor('Green')
oplot, frequencies, pm, Thick=4, Color=cgColor('Red')
oplot, frequencies, 100.*significance/max(pm1), color=cgColor('Black'), linest=3, Thick=3
sjhline, 105, color=cgColor('Black')
sjvline, frequencies, color=cgColor('Navy'), yrange=[105,119]
xyouts, xr[0]+((xr[1]-xr[0])/2.), 135, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, title, color=cgColor('Black')
; --------------------------------------------------------------------------------


walsa_endeps, filename='Figures/Fig3_power_spectra_1D_signal'

!P.Multi = 0
Cleanplot, /Silent

done
stop
end
