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
; NAME: WaLSA_Bomega
;       part of -- WaLSAtools --
;
; PURPOSE:   
;   Compute (and plot) B-ω diagram: average FFT power spectra 
;            for various magnetic-field bins within the FoV
;            Note: (1) The entire cube is detrended (linearly) 
;            and apodized (in both spatial and temporal domains)
;            prior to the FFT analysis
;            (2) Plotted B-ω is smoothed for better visibility
;
; CALLING SEQUENCE:
;   walsa_bomega, datacube, Bmap, time, power=power, frequencies=frequencies, Barray=Barray
;
; + INPUTS:
;   datacube:   datacube in the form of [x, y, t]
;   bmap:       magnetic-field map (in G), in the form of [x, y]
;               -- should spatially be the same size as the datacube
;   time:       time of the observations in sec
;
; + OPTIONAL KEYWORDS:
;   binsize:         magnetic-field bin size (default: 50 G)
;   silent:          if set, the B-ω map is not displayed.
;   clt:             color table number (idl ctload)
;   koclt:           custom color tables for k-ω diagram (currently available: 1 and 2)
;   threemin:        if set, a horizontal line marks the three-minute periodicity
;   fivemin:         if set, a horizontal line marks the five-minute periodicity
;   xlog:            if set, x-axis (magnetic field) is plotted in logarithmic scale
;   ylog:            if set, y-axis (frequency) is plotted in logarithmic scale
;   xrange:          x-axis (wavenumber) range
;   yrange:          y-axis (frequency) range
;   noy2:            if set, 2nd y-axis (period, in sec) is not plotted
;                    (p = 1000/frequency)
;   smooth:          if set, power is smoothed
;   normalizedbins   if set, power at each bin is normalized to its maximum value
;                    (this facilitates visibility of relatively small power)
;   xtickinterval    x-asis (i.e., magnetic fields) tick intervals in G (default: 400 G)   
;   epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made
;   mode:            outputted power mode: 0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
; ---- detrending, and apodization parameters----
;   apod:           extent of apodization edges (of a Tukey window); default 0.1
;   nodetrendapod:  if set, neither detrending nor apodization is performed!
;   pxdetrend:      subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
;   polyfit:        the degree of polynomial fit to the data to detrend it.
;                   if set, instead of linear fit this polynomial fit is performed.
;   meantemporal:   if set, only a very simple temporal detrending is performed by subtracting the mean signal from the signal.
;                   i.e., the fitting procedure (linear or higher polynomial degrees) is omitted.
;   meandetrend:    if set, subtract linear trend with time for the image means (i.e., spatial detrending)
;   recon:          optional keyword that will Fourier reconstruct the input timeseries.
;                   note: this does not preserve the amplitudes and is only useful when attempting 
;                   to examine frequencies that are far away from the 'untrustworthy' low frequencies.
;
; + OUTPUTS:
;   power:          B-ω map, a stack of average power spectra (in magnetic-field bins)
;                   along y axis -> The x and y axes are B (in G) and 
;                   frequency (in mHz); in dn^2/mhz, i.e., normalized to frequency resolution (see mode for the scale)
;   frequencies:    frequencies of the power spectra 
;                   (i.e., values of the y axis of the B-ω map)
;   barray:         magnetic-field values of the middle of the bins
;                   (i.e., values of the x axis of the B-ω map)
;
;
; + CREDITS:
;   Author: Shahin Jafarzadeh, March 2021. 
;   Note: if YOU USE THIS CODE, then PLEASE CITE THE ORIGINAL PUBLICATION WHERE IT WAS INTRODUCED:
;          Stangalini et al. 2021, A&A, in press (https://ui.adsabs.harvard.edu/abs/2021arXiv210311639S)
;-

pro walsa_bomega, datacube, Bmap, cadence=cadence, time=time, binsize=binsize, power=power, frequencies=frequencies, Barray=Barray, $
                  silent=silent, clt=clt, koclt=koclt, threemin=threemin, fivemin=fivemin, xlog=xlog, ylog=ylog, $ ; plotting keywords
                  xrange=xrange, yrange=yrange, epsfilename=epsfilename, noy2=noy2, smooth=smooth, normalizedbins=normalizedbins, $
                  xtickinterval=xtickinterval, mode=mode

if n_elements(cadence) eq 0 then cadence=walsa_mode(walsa_diff(time))

nx = N_ELEMENTS(datacube[*,0,0])
ny = N_ELEMENTS(datacube[0,*,0])
nt = N_ELEMENTS(datacube[0,0,*])

temporal_Nyquist = 1. / (cadence * 2.)

print,' '
print,'The input datacube is of size: ['+strtrim(nx,2)+', '+strtrim(ny,2)+', '+strtrim(nt,2)+']'
print,' '
print,'Temporally, the important values are:'
print,'    2-element duration (Nyquist period) = '+strtrim((cadence * 2.),2)+' seconds'
print,'    Time series duration = '+strtrim(cadence*nt,2)+' seconds'
print,'    Nyquist frequency = '+strtrim(temporal_Nyquist*1000.,2)+' mHz'
print, ' '

nxb = N_ELEMENTS(Bmap[*,0,0])
nyb = N_ELEMENTS(Bmap[0,*,0])

dimensions = GET_SCREEN_SIZE(RESOLUTION=resolution)
xscreensize = dimensions[0]
yscreensize = dimensions[1]
IF (xscreensize le yscreensize) THEN smallest_screensize = xscreensize
IF (yscreensize le xscreensize) THEN smallest_screensize = yscreensize

if nx gt nxb OR ny gt nyb then begin
    print, ' [!] The datacube and B-map must have the same [x,y] size.'
    print, ' '
    stop
endif

if n_elements(binsize) eq 0 then binsize = 50. ; in G
if n_elements(silent) eq 0 then silent = 0
if n_elements(noy2) eq 0 then noy2 = 0
if n_elements(normalizedbins) eq 0 then normalizedbins = 0 else normalizedbins = 1 
if n_elements(epsfilename) eq 0 then eps = 0 else eps = 1 
if n_elements(xtickinterval) eq 0 then xtickinterval = 400 ; in G
if n_elements(mode) eq 0 then mode=0
if n_elements(xlog) eq 0 then xlog = 0
if n_elements(ylog) eq 0 then ylog = 0
if n_elements(nodetrendapod) eq 0 then nodetrendapod = 0 else nodetrendapod = 1

Bmap = ABS(Bmap)

brange = minmax(Bmap, /nan)
nbin = floor((brange[1]-brange[0])/binsize)

; detrend and apodize the cube
if nodetrendapod eq 0 then begin
    print, ' '
    print, ' -- Detrend and apodize the cube .....'
    datacube=walsa_detrend_apod(datacube,apod,meandetrend,pxdetrend,polyfit=polyfit,meantemporal=meantemporal,recon=recon,cadence=cadence) 
endif

frequencies = 1./(cadence*2)*findgen(nt/2+1)/(nt/2)
nff=n_elements(frequencies)
frequencies = frequencies[1:nff-1]
frequencies = frequencies*1000. ; in mHz

numf = n_elements(frequencies)

Barray = fltarr(nbin)
bopower = fltarr(nbin,numf)
fac = 0

PRINT
for i=0L, nbin-1 do begin
    ii = where(Bmap le brange[1]-(fac*float(binsize)) AND Bmap gt brange[1]-((fac+1)*float(binsize)),num)
    
    Barray[i] = (brange[1]-(fac*float(binsize)))-(float(binsize)/2.)
    
    if num gt 0 then begin
        coords = array_indices(Bmap,ii)
        xx = reform(coords[0,*])  &  yy = reform(coords[1,*])
        nxy = n_elements(xx)
        
        poweravg = fltarr(numf)
        for ixy=0L, nxy-1 do begin
            poweri = (2.*(ABS((fft(reform(datacube[xx[ixy],yy[ixy],*]),-1))[0:nt/2.])^2))/frequencies[0] ; in DN^2/mHz
            poweravg = poweravg + poweri[1:nff-1]
        endfor
        poweravg = poweravg/float(nxy)
        
        if normalizedbins eq 1 then poweravg = 100.*poweravg/max(poweravg)
        
        bopower[i,*] = poweravg
    endif
    
    print,string(13b)+'.... % finished (through bins, from larger B): ',float(i)*100./(nbin-1),format='(a,f4.0,$)'
    
    if brange[1]-((fac+1)*float(binsize)) le 0 then break
    fac = fac+1
endfor
PRINT

bopower = reverse(bopower,1)
Barray = reverse(Barray)
nb = n_elements(Barray)

Barray[0]=brange[0]
Barray[nb-1]=brange[1]

ppp = bopower

Gaussian_kernel = GAUSSIAN_FUNCTION([0.65,0.65], WIDTH=3, MAXIMUM=1, /double)
Gaussian_kernel_norm = TOTAL(Gaussian_kernel,/nan)
bopower = CONVOL(bopower,  Gaussian_kernel, Gaussian_kernel_norm, /edge_truncate)

if mode eq 0 then bopower = ALOG10(bopower)
if mode eq 2 then bopower = SQRT(bopower)

nlevels = 256
step = (Max(bopower) - Min(bopower)) / nlevels
vals = Indgen(nlevels) * step + Min(bopower)

bopower = (bopower)[0:*,0:*]>MIN((bopower)[0:*,0:*],/nan)<MAX((bopower)[0:*,0:*],/nan)

if silent eq 0 then begin

    LOADCT, 0, /silent
    !p.background = 255.
    !p.color = 0.
    x1 = 0.12 
    x2 = 0.86 
    y1 = 0.10
    y2 = 0.80

    if n_elements(clt) eq 0 then clt = 13 else clt=clt 
    ctload, clt, /silent 
    if n_elements(koclt) ne 0 then walsa_powercolor, koclt

    !p.background = 255.
    !p.color = 0.

    positioncb=[x1,y2+0.05,x2,y2+0.07]

    if EPS eq 1 then begin
        walsa_eps, size=[20,22]
        !p.font=0
        device,set_font='Times-Roman'
        !p.charsize=1.3
        !x.thick=4.
        !y.thick=4.
        !x.ticklen=-0.025
        !y.ticklen=-0.025
    endif else begin
        if (xscreensize ge 1000) AND (yscreensize ge 1000) then begin 
            WINdoW, 0, xsize=1000, ysize=1000, title='B-omega diagram'
            !p.charsize=1.7
            !p.charthick=1
            !x.thick=2
            !y.thick=2
            !x.ticklen=-0.025
            !y.ticklen=-0.025
        endif
        if (xscreensize lt 1000) OR  (yscreensize lt 1000) then begin 
            WINdoW, 0, xsize=FIX(smallest_screensize*0.9), ysize=FIX(smallest_screensize*0.9), title='B-omega diagram'
            !p.charsize=1
            !p.charthick=1
            !x.thick=2
            !y.thick=2
            !x.ticklen=-0.025
            !y.ticklen=-0.025       
        endif
    endelse
    
    walsa_pg_plotimage_komega, bopower, Barray, frequencies, $
        ytitle='Frequency (mHz)', xtitle='B (G)', xst=1, yst=8, xlog=xlog, ylog=ylog, xrange=xrange, yrange=yrange, eps=eps, $
        position=[x1, y1, x2, y2], noy2=noy2, nox2=1, smooth=smooth, threemin=threemin, fivemin=fivemin, xtickinter=xtickinterval

    tickmarknames = STRARR(4)
    tickmarknames[0] = STRING(MIN(bopower[1:*,1:*],/nan), FORMAT='(F5.1)')
    tickmarknames[1] = STRING(((MAX(bopower[1:*,1:*],/nan)-MIN(bopower[1:*,1:*],/nan)) * 0.33) + MIN(bopower[1:*,1:*],/nan), FORMAT='(F5.1)')
    tickmarknames[2] = STRING(((MAX(bopower[1:*,1:*],/nan)-MIN(bopower[1:*,1:*],/nan)) * 0.67) + MIN(bopower[1:*,1:*],/nan), FORMAT='(F4.1)')
    tickmarknames[3] = STRING(MAX(bopower[1:*,1:*],/nan), FORMAT='(F4.1)')

    if normalizedbins eq 1 then cbtitle='Log!d10!n(Normalized Oscillation Power)' else cbtitle='Log!d10!n(Oscillation Power)'
	
    cgcolorbar, bottom=0, ncolors=255,  minrange=MIN(bopower[1:*,1:*],/nan), maxrange=MAX(bopower[1:*,1:*],/nan), /top, $
        ticknames=tickmarknames, yticklen=0.00001, position=positioncb, title=cbtitle
    
    if EPS eq 1 then walsa_endeps, filename=epsfilename, /noboundingbox
endif

power = bopower

PRINT
if (mode eq 0) then print,' mode = 0: log(power)'
if (mode eq 1) then print,' mode = 1: linear power' 
if (mode eq 2) then print,' mode = 2: sqrt(power)'

!P.Multi = 0
Cleanplot, /Silent

PRINT
PRINT, 'COMPLETED!'
PRINT

end
