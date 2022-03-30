;+
; NAME: WaLSA_QUB_QUEEFF
;       part of -- WaLSAtools --
;
; ORIGINAL CODE: QUEEns Fourier Filtering (QUEEFF) code
; WRITTEN, ANNOTATED, TESTED AND UPDATED BY:
; (1) Dr. David B. Jess
; (2) Dr. Samuel D. T. Grant
; The original code along with its manual can be downloaded at: https://bit.ly/37mx9ic
;
; WaLSA_QUB_QUEEFF: Slightly modified (i.e., a few additional keywords added) by Shahin Jafarzadeh
;
; CHECK DEPENDENCIES (MAKE SURE ALL REQUIRED PROGRAMMES ARE INSTALLED):
; NOTE
; @/Users/dbj/ARC/IDL_programmes/Fourier_filtering/QUEEFF_code/QUEEFF_dependencies.bat
;
; CALLING SEQUENCE:
;   EXAMPLES:
;   walsa_qub_queeff, datacube, arcsecpx, time=time, power=power, wavenumber=wavenumber, frequencies=frequencies, koclt=1
;   walsa_qub_queeff, datacube, arcsecpx, cadence, /filtering, power=power, wavenumber=wavenumber, frequencies=frequencies, filtered_cube=filtered_cube
;
; + INPUTS:
;   datacube   input datacube, normally in the form of [x, y, t] 
;              [note - at present the input datacube needs to have identical x and y dimensions. if not supplied like this the datacube will be cropped accordingly!]
;   cadence    delta time between sucessive frames - given in seconds. if not set, time must be provided (see optional inputs)
;   arcsecpx   spatial sampling of the input datacube - given in arcseconds per pixel
;
; + OPTIONAL INPUTS:
; (if optional inputs not supplied, the user will need to interact with the displayed k-omega diagram to define these values)
;   time             observing times in seconds (1d array). it is ignored if cadence is provided
;   filtering        if set, filterring is proceeded
;   f1               optional lower (temporal) frequency to filter - given in mhz
;   f2               optional upper (temporal) frequency to filter - given in mhz
;   k1               optional lower (spatial) wavenumber to filter - given in arcsec^-1 (where k = (2*!pi)/wavelength)
;   k2               optional upper (spatial) wavenumber to filter - given in arcsec^-1 (where k = (2*!pi)/wavelength)
;   spatial_torus    makes the annulus used for spatial filtering have a gaussian-shaped profile (useful for preventing aliasing). default: 1
;                    if equal to 0, it is not applied.
;   temporal_torus   makes the temporal filter have a gaussian-shaped profile (useful for preventing aliasing). default: 1
;                    if equal to 0, it is not applied.
;   no_spatial_filt  optional keyword that ensures no spatial filtering is performed on the dataset (i.e., only temporal filtering)
;   no_temporal_filt optional keyword that ensures no temporal filtering is performed on the dataset (i.e., only spatial filtering)
;   silent:          if set, the k-ω diagram is not plotted
;   clt:             color table number (idl ctload)
;   koclt:           custom color tables for k-ω diagram (currently available: 1 and 2)
;   threemin:        if set, a horizontal line marks the three-minute periodicity
;   fivemin:         if set, a horizontal line marks the five-minute periodicity
;   xlog:            if set, x-axis (wavenumber) is plotted in logarithmic scale (base 10)
;   ylog:            if set, y-axis (frequency) is plotted in logarithmic scale (base 10)
;   xrange:          x-axis (wavenumber) range
;   yrange:          y-axis (frequency) range
;   nox2:            if set, 2nd x-axis (spatial size, in arcsec) is not plotted
;                    (spatial size (i.e., wavelength) = (2*!pi)/wavenumber)
;   noy2:            if set, 2nd y-axis (period, in sec) is not plotted
;                    (p = 1000/frequency)
;   smooth:          if set, power is smoothed
;   epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made
;   mode:            outputted power mode: 0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
;
; + OUTPUTS:
;   power:           2d array of power (see mode for the scale)
;                    (in dn^2/mhz, i.e., normalized to frequency resolution)
;   frequencies:     1d array of frequencies (in mhz)
;   wavenumber:      1d array of wavenumber (in arcsec^-1)
;   filtered_cube:   3d array of filtered datacube (if filtering is set)
;
;
; IF YOU USE THIS CODE, THEN PLEASE CITE THE ORIGINAL PUBLICATION WHERE IT WAS USED:
; Jess et al. 2017, ApJ, 842, 59 (http://adsabs.harvard.edu/abs/2017ApJ...842...59J)
;-

pro walsa_qub_queeff, datacube, arcsecpx, cadence=cadence, time=time, $ ; main inputs
                      power=power, wavenumber=wavenumber, frequencies=frequencies, filtered_cube=filtered_cube, $ ; main (additional) outputs
                      filtering=filtering, f1=f1, f2=f2, k1=k1, k2=k2, spatial_torus=spatial_torus, temporal_torus=temporal_torus, $ ; filtering options
                      no_spatial_filt=no_spatial_filt, no_temporal_filt=no_temporal_filt, $
                      clt=clt, koclt=koclt, threemin=threemin, fivemin=fivemin, xlog=xlog, ylog=ylog, xrange=xrange, yrange=yrange, $ ; plotting keywords
                      epsfilename=epsfilename, noy2=noy2, nox2=nox2, smooth=smooth, silent=silent, mode=mode

if n_elements(cadence) eq 0 then cadence=walsa_mode(walsa_diff(time))
; DEFINE THE SCREEN RESOLUTION TO ENSURE THE PLOTS DO NOT SPILL OVER THE EDGES OF THE SCREEN
dimensions = GET_SCREEN_SIZE(RESOLUTION=resolution)
xscreensize = dimensions[0]
yscreensize = dimensions[1]
IF (xscreensize le yscreensize) THEN smallest_screensize = xscreensize
IF (yscreensize le xscreensize) THEN smallest_screensize = yscreensize

xsize_cube = N_ELEMENTS(datacube[*,0,0])
ysize_cube = N_ELEMENTS(datacube[0,*,0])
zsize_cube = N_ELEMENTS(datacube[0,0,*])

; FORCE THE CUBES TO HAVE THE SAME SPATIAL DIMENSIONS
IF xsize_cube gt ysize_cube THEN datacube = TEMPORARY(datacube[0:(ysize_cube-1), *, *])
IF xsize_cube gt ysize_cube THEN xsize_cube = ysize_cube
IF ysize_cube gt xsize_cube THEN datacube = TEMPORARY(datacube[*, 0:(xsize_cube-1), *])
IF ysize_cube gt xsize_cube THEN ysize_cube = xsize_cube

if n_elements(spatial_torus) eq 0 then spatial_torus = 1
if n_elements(temporal_torus) eq 0 then temporal_torus = 1

if n_elements(xlog) eq 0 then xlog = 0
if n_elements(ylog) eq 0 then ylog = 0
if n_elements(nox2) eq 0 then nox2 = 0
if n_elements(noy2) eq 0 then noy2 = 0
if not keyword_set(mode) then mode=0
if n_elements(epsfilename) eq 0 then eps = 0 else eps = 1

if n_elements(silent) eq 0 then silent = 0
if n_elements(filtering) eq 0 then filtering = 0 else silent = 0
 
; CALCULATE THE NYQUIST FREQUENCIES
spatial_Nyquist  = (2.*!pi) / (arcsecpx * 2.)
temporal_Nyquist = 1. / (cadence * 2.)

print,''
print,'The input datacube is of size: ['+strtrim(xsize_cube,2)+', '+strtrim(ysize_cube,2)+', '+strtrim(zsize_cube,2)+']'
print,''
print,'Spatially, the important values are:'
print,'    2-pixel size = '+strtrim((arcsecpx * 2.),2)+' arcsec'
print,'    Field of view size = '+strtrim((arcsecpx * xsize_cube),2)+' arcsec'
print,'    Nyquist wavenumber = '+strtrim(spatial_Nyquist,2)+' arcsec^-1'
IF KEYWORD_SET(no_spatial_filt) THEN print, '***NO SPATIAL FILTERING WILL BE PERFORMED***'
print,''
print,'Temporally, the important values are:'
print,'    2-element duration (Nyquist period) = '+strtrim((cadence * 2.),2)+' seconds'
print,'    Time series duration = '+strtrim(cadence*zsize_cube,2)+' seconds'
print,'    Nyquist frequency = '+strtrim(temporal_Nyquist*1000.,2)+' mHz'
IF KEYWORD_SET(no_temporal_filt) THEN print, '***NO TEMPORAL FILTERING WILL BE PERFORMED***'

; MAKE A k-omega DIAGRAM
sp_out = DBLARR(xsize_cube/2,zsize_cube/2)
print,''
print,'Constructing a k-omega diagram of the input datacube..........'
print,''
; MAKE THE k-omega DIAGRAM USING THE PROVEN METHOD OF ROB RUTTEN
kopower = walsa_plotkopower_funct(datacube, sp_out, arcsecpx, cadence, apod=0.1,  kmax=1., fmax=1.)
   ; X SIZE STUFF
   xsize_kopower  = N_ELEMENTS(kopower[*,0])
   dxsize_kopower = spatial_Nyquist / FLOAT(xsize_kopower-1.)
   kopower_xscale = (FINDGEN(xsize_kopower)*dxsize_kopower) ; IN arcsec^-1
      ; Y SIZE STUFF
      ysize_kopower  = N_ELEMENTS(kopower[0,*])
      dysize_kopower = temporal_Nyquist / FLOAT(ysize_kopower-1.)
      kopower_yscale = (FINDGEN(ysize_kopower)*dysize_kopower) * 1000. ; IN mHz
Gaussian_kernel = GAUSSIAN_FUNCTION([0.65,0.65], WIDTH=3, MAXIMUM=1, /double)
Gaussian_kernel_norm = TOTAL(Gaussian_kernel,/nan)
kopower_plot = kopower
kopower_plot[*,1:*] = CONVOL(kopower[*,1:*],  Gaussian_kernel, Gaussian_kernel_norm, /edge_truncate)

; normalise to frequency resolution (in mHz)
freq = kopower_yscale[1:*]
if freq[0] eq 0 then freq0 = freq[1] else freq0 = freq[0]
kopower_plot = kopower_plot/freq0

if mode eq 0 then kopower_plot = ALOG10(kopower_plot)
if mode eq 2 then kopower_plot = SQRT(kopower_plot)

LOADCT, 0, /silent
!p.background = 255.
!p.color = 0.
x1 = 0.12 
x2 = 0.86 
y1 = 0.10
y2 = 0.80

!p.background = 255.
!p.color = 0.

; WHEN PLOTTING WE NEED TO IGNORE THE ZERO'TH ELEMENT (I.E., THE MEAN f=0) SINCE THIS WILL MESS UP THE LOG PLOT!
komegamap = (kopower_plot)[1:*,1:*]>MIN((kopower_plot)[1:*,1:*],/nan)<MAX((kopower_plot)[1:*,1:*],/nan)

IF silent EQ 0 THEN BEGIN
    
    if n_elements(komega) eq 0 then komega = 0 else komega = 1 
    if n_elements(clt) eq 0 then clt = 13 else clt=clt 
    ctload, clt, /silent 
    if n_elements(koclt) ne 0 then walsa_powercolor, koclt

    !p.background = 255.
    !p.color = 0.

    positioncb=[x1,y2+0.11,x2,y2+0.13]

    IF EPS eq 1 THEN BEGIN
        walsa_eps, size=[20,22]
        !p.font=0
        device,set_font='Times-Roman'
        !p.charsize=1.3
        !x.thick=4.
        !y.thick=4.
        !x.ticklen=-0.025
        !y.ticklen=-0.025
        positioncb=[x1,y2+0.12,x2,y2+0.14]
    ENDIF ELSE BEGIN
        IF (xscreensize ge 1000) AND (yscreensize ge 1000) THEN BEGIN 
            WINDOW, 0, xsize=1000, ysize=1000, title='QUEEFF: k-omega diagram'
            !p.charsize=1.7
            !p.charthick=1
            !x.thick=2
            !y.thick=2
            !x.ticklen=-0.025
            !y.ticklen=-0.025
        ENDIF
        IF (xscreensize lt 1000) OR  (yscreensize lt 1000) THEN BEGIN 
            WINDOW, 0, xsize=FIX(smallest_screensize*0.9), ysize=FIX(smallest_screensize*0.9), title='QUEEFF: k-omega diagram'
            !p.charsize=1
            !p.charthick=1
            !x.thick=2
            !y.thick=2
            !x.ticklen=-0.025
            !y.ticklen=-0.025       
        ENDIF
    ENDELSE

    walsa_pg_plotimage_komega, komegamap, kopower_xscale[1:*], kopower_yscale[1:*], noy2=noy2, nox2=nox2, smooth=smooth, $
        xtitle='Wavenumber (arcsec!U-1!N)', ytitle='Frequency (mHz)', xst=8, yst=8, xlog=xlog, ylog=ylog, position=[x1, y1, x2, y2], $
        xrange=xrange, yrange=yrange, threemin=threemin, fivemin=fivemin, eps=eps

    tickmarknames = STRARR(4)
    tickmarknames[0] = STRING(MIN(kopower_plot[1:*,1:*],/nan), FORMAT='(F5.1)')
    tickmarknames[1] = STRING(((MAX(kopower_plot[1:*,1:*],/nan)-MIN(kopower_plot[1:*,1:*],/nan)) * 0.33) + MIN(kopower_plot[1:*,1:*],/nan), FORMAT='(F5.1)')
    tickmarknames[2] = STRING(((MAX(kopower_plot[1:*,1:*],/nan)-MIN(kopower_plot[1:*,1:*],/nan)) * 0.67) + MIN(kopower_plot[1:*,1:*],/nan), FORMAT='(F4.1)')
    tickmarknames[3] = STRING(MAX(kopower_plot[1:*,1:*],/nan), FORMAT='(F4.1)')

    cgcolorbar, bottom=0, ncolors=255, divisions=3, minrange=MIN(kopower_plot[1:*,1:*],/nan), maxrange=MAX(kopower_plot[1:*,1:*],/nan), $
        position=positioncb, /top, ticknames=tickmarknames, title='Log!d10!n(Oscillation Power)', yticklen=0.00001

ENDIF

IF EPS eq 1 THEN walsa_endeps, filename=epsfilename, /noboundingbox

power = komegamap
wavenumber = kopower_xscale[1:*]
frequencies = kopower_yscale[1:*]

print, ' '
if filtering then print, ' ..... start filtering (in k-ω space)' else return
print, ' '

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; STEPS USED TO MAKE SURE THE FREQUENCIES ARE CHOSEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NEED f1 AND k1
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, ''
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the LOWEST frequency/wavenumber value you wish to preserve.....'
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN CURSOR, k1, f1, /data
WAIT, 1.0
; NEED f2 AND k2
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, ''
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the HIGHEST frequency/wavenumber value you wish to preserve.....'
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN CURSOR, k2, f2, /data
WAIT, 1.0
; NEED ONLY f1 (spatial filtering ON)
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymin = 10^MIN(!y.crange,/nan)
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymax = 10^MAX(!y.crange,/nan)
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [k1, k1], [kopower_plot_ymin, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [k2, k2], [kopower_plot_ymin, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, ''
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the LOWEST frequency value you wish to preserve inside the dotted lines.....'
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN CURSOR, nonsense, f1, /data
WAIT, 1.0
; NEED ONLY f2 (spatial filtering ON)
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymin = 10^MIN(!y.crange,/nan)
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymax = 10^MAX(!y.crange,/nan)
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [k1, k1], [kopower_plot_ymin, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [k2, k2], [kopower_plot_ymin, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, ''
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the HIGHEST frequency value you wish to preserve inside the dotted lines.....'
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN CURSOR, nonsense, f2, /data
WAIT, 1.0
; NEED ONLY f1 (spatial filtering OFF)
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymin = 10^MIN(!y.crange,/nan)
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymax = 10^MAX(!y.crange,/nan)
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmin = 10^MIN(!x.crange,/nan)
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmax = 10^MAX(!x.crange,/nan)
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmin], [kopower_plot_ymin, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmax, kopower_plot_xmax], [kopower_plot_ymin, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, ''
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the LOWEST frequency value you wish to preserve inside the dotted lines.....'
IF NOT KEYWORD_SET(f1) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN CURSOR, nonsense, f1, /data
WAIT, 1.0
; NEED ONLY f2 (spatial filtering OFF)
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymin = 10^MIN(!y.crange,/nan)
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymax = 10^MAX(!y.crange,/nan)
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmin = 10^MIN(!x.crange,/nan)
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmax = 10^MAX(!x.crange,/nan)
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmin], [kopower_plot_ymin, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmax, kopower_plot_xmax], [kopower_plot_ymin, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, ''
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the HIGHEST frequency value you wish to preserve inside the dotted lines.....'
IF NOT KEYWORD_SET(f2) AND KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN CURSOR, nonsense, f2, /data
WAIT, 1.0
; NEED ONLY k1 (temporal filtering ON)
IF KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmin = 10^MIN(!x.crange,/nan)
IF KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmax = 10^MAX(!x.crange,/nan)
IF KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmax], [f1, f1], line=1, thick=3, color=255
IF KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmax], [f2, f2], line=1, thick=3, color=255
IF KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, ''
IF KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the LOWEST wavenumber value you wish to preserve inside the dotted lines.....'
IF KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN CURSOR, k1, nonsense, /data
WAIT, 1.0
; NEED ONLY k2 (temporal filtering ON)
IF KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmin = 10^MIN(!x.crange,/nan)
IF KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmax = 10^MAX(!x.crange,/nan)
IF KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmax], [f1, f1], line=1, thick=3, color=255
IF KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmax], [f2, f2], line=1, thick=3, color=255
IF KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, ''
IF KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the HIGHEST wavenumber value you wish to preserve inside the dotted lines.....'
IF KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND NOT KEYWORD_SET(no_temporal_filt) THEN CURSOR, k2, nonsense, /data
WAIT, 1.0
; NEED ONLY k1 (temporal filtering ON)
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymin = 10^MIN(!y.crange,/nan)
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymax = 10^MAX(!y.crange,/nan)
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmin = 10^MIN(!x.crange,/nan)
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmax = 10^MAX(!x.crange,/nan)
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmax], [kopower_plot_ymin, kopower_plot_ymin], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmax], [kopower_plot_ymax, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN print, ''
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the LOWEST wavenumber value you wish to preserve inside the dotted lines.....'
IF NOT KEYWORD_SET(f1) AND NOT KEYWORD_SET(k1) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN CURSOR, k1, nonsense, /data
WAIT, 1.0
; NEED ONLY k2 (temporal filtering ON)
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmin = 10^MIN(!x.crange,/nan)
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN kopower_plot_xmax = 10^MAX(!x.crange,/nan)
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymin = 10^MIN(!y.crange,/nan)
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN kopower_plot_ymax = 10^MAX(!y.crange,/nan)
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmax], [kopower_plot_ymin, kopower_plot_ymin], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN PLOTS, [kopower_plot_xmin, kopower_plot_xmax], [kopower_plot_ymax, kopower_plot_ymax], line=1, thick=3, color=255
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN print, ''
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN print, 'Please click on the HIGHEST wavenumber value you wish to preserve inside the dotted lines.....'
IF NOT KEYWORD_SET(f2) AND NOT KEYWORD_SET(k2) AND NOT KEYWORD_SET(no_spatial_filt) AND KEYWORD_SET(no_temporal_filt) THEN CURSOR, k2, nonsense, /data
WAIT, 1.0
IF KEYWORD_SET(no_spatial_filt) THEN k1 = kopower_xscale[1]
IF KEYWORD_SET(no_spatial_filt) THEN k2 = MAX(kopower_xscale,/nan)
IF KEYWORD_SET(no_temporal_filt) THEN f1 = kopower_yscale[1]
IF KEYWORD_SET(no_temporal_filt) THEN f2 = MAX(kopower_yscale,/nan)
IF (k1 le 0.0) THEN k1 = kopower_xscale[1]
IF (k2 gt MAX(kopower_xscale,/nan)) THEN k2 = MAX(kopower_xscale,/nan)
IF (f1 le 0.0) THEN f1 = kopower_yscale[1]
IF (f2 gt MAX(kopower_yscale,/nan)) THEN f2 = MAX(kopower_yscale,/nan)
IF NOT KEYWORD_SET(no_spatial_filt) THEN BEGIN
    PLOTS, [k1, k2], [f1, f1], line=2, thick=2, color=255
    PLOTS, [k1, k2], [f2, f2], line=2, thick=2, color=255
    PLOTS, [k1, k1], [f1, f2], line=2, thick=2, color=255
    PLOTS, [k2, k2], [f1, f2], line=2, thick=2, color=255
ENDIF
IF KEYWORD_SET(no_spatial_filt) THEN BEGIN
    k1 = kopower_xscale[1]
    k2 = MAX(kopower_xscale,/nan)
    PLOTS, [k1, k2], [f1, f1], line=2, thick=2, color=255
    PLOTS, [k1, k2], [f2, f2], line=2, thick=2, color=255
    PLOTS, [k1, k1], [f1, f2], line=2, thick=2, color=255
    PLOTS, [k2, k2], [f1, f2], line=2, thick=2, color=255
ENDIF
print, ''
print, 'The preserved wavenumbers are ['+strtrim(k1, 2)+', '+strtrim(k2, 2)+'] arcsec^-1'
print, 'The preserved spatial sizes are ['+strtrim((2.*!pi)/k2, 2)+', '+strtrim((2.*!pi)/k1,2)+'] arcsec'
print,''
print, 'The preserved frequencies are ['+strtrim(f1, 2)+', '+strtrim(f2, 2)+'] mHz'
print, 'The preserved periods are ['+strtrim(FIX(1./(f2/1000.)), 2)+', '+strtrim(FIX(1./(f1/1000.)),2)+'] seconds'

pwavenumber = [k1,k2]
pspatialsize = [(2.*!pi)/k2,(2.*!pi)/k1]
pfrequency = [f1,f2]
pperiod = [FIX(1./(f2/1000.)),FIX(1./(f1/1000.))]

print,''
print,'Making a 3D Fourier transform of the input datacube..........'
threedft = FFT(datacube, -1, /double, /center)

; CALCULATE THE FREQUENCY AXES FOR THE 3D FFT
temp_x = FINDGEN((xsize_cube - 1)/2) + 1
is_N_even = (xsize_cube MOD 2) EQ 0
IF (is_N_even) THEN $
    spatial_frequencies_orig = ([0.0, temp_x, xsize_cube/2, -xsize_cube/2 + temp_x]/(xsize_cube*arcsecpx)) * (2.*!pi) $
    ELSE $
    spatial_frequencies_orig = ([0.0, temp_x, -(xsize_cube/2 + 1) + temp_x]/(xsize_cube*arcsecpx)) * (2.*!pi)
temp_x = FINDGEN((zsize_cube - 1)/2) + 1
is_N_even = (zsize_cube MOD 2) EQ 0
IF (is_N_even) THEN $
    temporal_frequencies_orig = [0.0, temp_x, zsize_cube/2, -zsize_cube/2 + temp_x]/(zsize_cube*cadence) $
    ELSE $
    temporal_frequencies_orig = [0.0, temp_x, -(zsize_cube/2 + 1) + temp_x]/(zsize_cube*cadence)
    
; NOW COMPENSATE THESE FREQUENCY AXES DUE TO THE FACT THE /center KEYWORD IS USED FOR THE FFT TRANSFORM
spatial_positive_frequencies = N_ELEMENTS(WHERE(spatial_frequencies_orig ge 0.))
IF N_ELEMENTS(spatial_frequencies_orig) MOD 2 EQ 0 THEN spatial_frequencies = SHIFT(spatial_frequencies_orig, (spatial_positive_frequencies-2))
IF N_ELEMENTS(spatial_frequencies_orig) MOD 2 NE 0 THEN spatial_frequencies = SHIFT(spatial_frequencies_orig, (spatial_positive_frequencies-1))
temporal_positive_frequencies = N_ELEMENTS(WHERE(temporal_frequencies_orig ge 0.))
IF N_ELEMENTS(temporal_frequencies_orig) MOD 2 EQ 0 THEN temporal_frequencies = SHIFT(temporal_frequencies_orig, (temporal_positive_frequencies-2))
IF N_ELEMENTS(temporal_frequencies_orig) MOD 2 NE 0 THEN temporal_frequencies = SHIFT(temporal_frequencies_orig, (temporal_positive_frequencies-1))

; ALSO NEED TO ENSURE THE threedft ALIGNS WITH THE NEW FREQUENCY AXES DESCRIBED ABOVE
IF N_ELEMENTS(temporal_frequencies_orig) MOD 2 EQ 0 THEN BEGIN
    FOR x = 0, (xsize_cube - 1) DO BEGIN
        FOR y = 0, (ysize_cube - 1) DO threedft[x, y, *] = SHIFT(REFORM(threedft[x,y,*]), -1)
    ENDFOR
ENDIF
IF N_ELEMENTS(spatial_frequencies_orig) MOD 2 EQ 0 THEN BEGIN
    FOR z = 0, (zsize_cube - 1) DO threedft[*, *, z] = SHIFT(REFORM(threedft[*,*,z]), [-1, -1])
ENDIF

; CONVERT FREQUENCIES AND WAVENUMBERS OF INTEREST INTO (FFT) DATACUBE PIXELS
pixel_k1_positive = walsa_closest(k1, spatial_frequencies_orig)
pixel_k2_positive = walsa_closest(k2, spatial_frequencies_orig)
pixel_f1_positive = walsa_closest(f1/1000., temporal_frequencies)
pixel_f2_positive = walsa_closest(f2/1000., temporal_frequencies)
pixel_f1_negative = walsa_closest(-f1/1000., temporal_frequencies)
pixel_f2_negative = walsa_closest(-f2/1000., temporal_frequencies)


torus_depth  = FIX((pixel_k2_positive[0] - pixel_k1_positive[0])/2.) * 2.
torus_center = FIX(((pixel_k2_positive[0] - pixel_k1_positive[0])/2.) + pixel_k1_positive[0])
IF KEYWORD_SET(spatial_torus) AND NOT KEYWORD_SET(no_spatial_filt) THEN BEGIN
    ; CREATE A FILTER RING PRESERVING EQUAL WAVENUMBERS FOR BOTH kx AND ky
    ; DO THIS AS A TORUS TO PRESERVE AN INTEGRATED GAUSSIAN SHAPE ACROSS THE WIDTH OF THE ANNULUS, THEN INTEGRATE ALONG 'z'
    spatial_torus = FLTARR(xsize_cube, ysize_cube, torus_depth)
    FOR i = 0, (FIX(torus_depth/2.)) DO BEGIN
        spatial_ring = (walsa_radial_distances([1,xsize_cube,ysize_cube]) LE (torus_center-i)) - $
                       (walsa_radial_distances([1,xsize_cube,ysize_cube]) LE (torus_center+i+1))
        spatial_ring[WHERE(spatial_ring gt 0.)] = 1.
        spatial_ring[WHERE(spatial_ring ne 1.)] = 0.
        spatial_torus[*,*,i] = spatial_ring
        spatial_torus[*,*,torus_depth-i-1] = spatial_ring
    ENDFOR
    ; INTEGRATE THROUGH THE TORUS TO FIND THE SPATIAL FILTER
    spatial_ring_filter      = TOTAL(spatial_torus,3,/nan) / FLOAT(torus_depth)
    spatial_ring_filter      = spatial_ring_filter / MAX(spatial_ring_filter,/nan) ; TO ENSURE THE PEAKS ARE AT 1.0
    ;IF N_ELEMENTS(spatial_frequencies_orig) MOD 2 EQ 0 THEN spatial_ring_filter = SHIFT(spatial_ring_filter, [-1,-1])
ENDIF

IF NOT KEYWORD_SET(spatial_torus) AND NOT KEYWORD_SET(no_spatial_filt) THEN BEGIN 
    spatial_ring_filter      = (walsa_radial_distances([1,xsize_cube,ysize_cube]) LE (torus_center-(FIX(torus_depth/2.)))) - $
                               (walsa_radial_distances([1,xsize_cube,ysize_cube]) LE (torus_center+(FIX(torus_depth/2.))+1))
    spatial_ring_filter      = spatial_ring_filter / MAX(spatial_ring_filter,/nan) ; TO ENSURE THE PEAKS ARE AT 1.0
    spatial_ring_filter[WHERE(spatial_ring_filter NE 1.)] = 0.
    ;IF N_ELEMENTS(spatial_frequencies_orig) MOD 2 EQ 0 THEN spatial_ring_filter = SHIFT(spatial_ring_filter, [-1,-1])
ENDIF

IF KEYWORD_SET(no_spatial_filt) THEN BEGIN
    spatial_ring_filter      = FLTARR(xsize_cube, ysize_cube)
    spatial_ring_filter[*]   = 1.
ENDIF

IF NOT KEYWORD_SET(no_temporal_filt) AND KEYWORD_SET(temporal_torus) THEN BEGIN
    ; CREATE A GAUSSIAN TEMPORAL FILTER TO PREVENT ALIASING
    temporal_filter    = FLTARR(zsize_cube)
    temporal_filter[*] = 0.
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 25) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(3, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 25) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 30) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(4, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 30) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 40) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(5, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 40) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 45) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(6, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 45) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 50) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(7, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 50) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 55) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(8, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 55) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 60) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(9, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 60) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 65) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(10, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 65) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 70) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(11, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 70) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 80) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(12, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 80) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 90) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(13, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 90) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 100) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(14, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 100) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 110) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(15, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 110) AND ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) LT 130) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(16, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    IF ((pixel_f2_positive[0]-pixel_f1_positive[0]+1) GE 130) THEN temporal_Gaussian = GAUSSIAN_FUNCTION(17, WIDTH=(pixel_f2_positive[0]-pixel_f1_positive[0]+1), MAXIMUM=1, /double)
    temporal_filter[pixel_f1_positive(0):pixel_f2_positive(0)] = temporal_Gaussian
    temporal_filter[pixel_f2_negative(0):pixel_f1_negative(0)] = temporal_Gaussian
    temporal_filter = temporal_filter / MAX(temporal_filter,/nan) ; TO ENSURE THE PEAKS ARE AT 1.0
ENDIF

IF NOT KEYWORD_SET(no_temporal_filt) AND NOT KEYWORD_SET(temporal_torus) THEN BEGIN
    temporal_filter    = FLTARR(zsize_cube)
    temporal_filter[*] = 0.
    temporal_filter[pixel_f1_positive(0):pixel_f2_positive(0)] = 1.0
    temporal_filter[pixel_f2_negative(0):pixel_f1_negative(0)] = 1.0
ENDIF


IF KEYWORD_SET(no_temporal_filt) THEN BEGIN
    temporal_filter    = FLTARR(zsize_cube)
    temporal_filter[*] = 1.
ENDIF


; MAKE SOME FIGURES FOR PLOTTING - MAKES THINGS AESTHETICALLY PLEASING!
torus_map = MAKE_MAP(spatial_ring_filter, dx=spatial_frequencies[1]-spatial_frequencies[0], dy=spatial_frequencies[1]-spatial_frequencies[0], xc=0, yc=0, time='', units='arcsecs')
spatial_fft = TOTAL(threedft, 3,/nan)
spatial_fft_map = MAKE_MAP(ALOG10(spatial_fft), dx=spatial_frequencies[1]-spatial_frequencies[0], dy=spatial_frequencies[1]-spatial_frequencies[0], xc=0, yc=0, time='', units='arcsecs')
spatial_fft_filtered = spatial_fft * spatial_ring_filter
spatial_fft_filtered_map = MAKE_MAP(ALOG10(spatial_fft_filtered>1e-15), dx=spatial_frequencies[1]-spatial_frequencies[0], dy=spatial_frequencies[1]-spatial_frequencies[0], xc=0, yc=0, time='', units='arcsecs')
temporal_fft = TOTAL(TOTAL(threedft, 2,/nan), 1)
IF (xscreensize ge 1000) AND (yscreensize ge 1000) THEN WINDOW, 1, xsize=1500, ysize=1000, title='QUEEFF: FFT filter specs'
IF (xscreensize lt 1000) OR  (yscreensize lt 1000) THEN WINDOW, 1, xsize=smallest_screensize, ysize=FIX(smallest_screensize*0.8), title='QUEEFF: FFT filter specs'
x1 = 0.07
x2 = 0.33
x3 = 0.40
x4 = 0.66
x5 = 0.72
x6 = 0.98
y1 = 0.07
y2 = 0.47
y3 = 0.56
y4 = 0.96
LOADCT, 5, /silent
IF (xscreensize ge 1000) AND (yscreensize ge 1000) THEN BEGIN 
    plot_map, spatial_fft_map, charsize=2, xticklen=-.025, yticklen=-.025, xtitle='Wavenumber (k!Dx!N ; arcsec!U-1!N)', ytitle='Wavenumber (k!Dy!N ; arcsec!U-1!N)', title='Spatial FFT', dmin=MIN(spatial_fft_map.data,/nan)+1., dmax=MAX(spatial_fft_map.data,/nan)-1., position=[x1, y3, x2, y4]
    PLOTS, [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], [0, 0], line=2, thick=2, color=0
    PLOTS, [0, 0], [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], line=2, thick=2, color=0
    LOADCT,0,/silent
    plot_map, torus_map, charsize=2, xticklen=-.025, yticklen=-.025, xtitle='Wavenumber (k!Dx!N ; arcsec!U-1!N)', ytitle='', title='Spatial FFT filter', dmin=0, dmax=1, position=[x3, y3, x4, y4], /noerase
    PLOTS, [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], [0, 0], line=2, thick=2, color=255
    PLOTS, [0, 0], [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], line=2, thick=2, color=255
    LOADCT,5,/silent
    plot_map, spatial_fft_filtered_map, charsize=2, xticklen=-.025, yticklen=-.025, xtitle='Wavenumber (k!Dx!N ; arcsec!U-1!N)', ytitle='', title='Filtered spatial FFT', dmin=MIN(spatial_fft_map.data,/nan)+1., dmax=MAX(spatial_fft_map.data,/nan)-1., position=[x5, y3, x6, y4], /noerase
    PLOTS, [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], [0, 0], line=2, thick=2, color=255
    PLOTS, [0, 0], [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], line=2, thick=2, color=255
    PLOT, temporal_frequencies*1000., ABS(temporal_fft), /ylog, xst=1, xticklen=-.026, yticklen=-.011, charsize=2, xtitle='Frequency (mHz)', ytitle='Power (arb. units)', position=[x1+0.05, y1, x6, y2], /noerase
    temporal_fft_plot_ymin = 10^MIN(!y.crange,/nan)
    temporal_fft_plot_ymax = 10^MAX(!y.crange,/nan)
    PLOTS, [0, 0], [temporal_fft_plot_ymin, temporal_fft_plot_ymax], line=2, thick=2, color=0
    LOADCT,39,/silent
    OPLOT, temporal_frequencies*1000., (temporal_filter)>temporal_fft_plot_ymin, line=2, color=55, thick=2
    OPLOT, temporal_frequencies*1000., (ABS(temporal_fft * temporal_filter))>temporal_fft_plot_ymin, line=0, color=254, thick=2
    LOADCT,5,/silent
    WAIT, 0.5
ENDIF
IF (xscreensize lt 1000) OR  (yscreensize lt 1000) THEN BEGIN 
    plot_map, spatial_fft_map, charsize=1, xticklen=-.025, yticklen=-.025, xtitle='Wavenumber (k!Dx!N ; arcsec!U-1!N)', ytitle='Wavenumber (k!Dy!N ; arcsec!U-1!N)', title='Spatial FFT', dmin=MIN(spatial_fft_map.data,/nan)+1., dmax=MAX(spatial_fft_map.data,/nan)-1., position=[x1, y3, x2, y4]
    PLOTS, [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], [0, 0], line=2, thick=2, color=0
    PLOTS, [0, 0], [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], line=2, thick=2, color=0
    LOADCT,0,/silent
    plot_map, torus_map, charsize=1, xticklen=-.025, yticklen=-.025, xtitle='Wavenumber (k!Dx!N ; arcsec!U-1!N)', ytitle='', title='Spatial FFT filter', dmin=0, dmax=1, position=[x3, y3, x4, y4], /noerase
    PLOTS, [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], [0, 0], line=2, thick=2, color=255
    PLOTS, [0, 0], [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], line=2, thick=2, color=255
    LOADCT,5,/silent
    plot_map, spatial_fft_filtered_map, charsize=1, xticklen=-.025, yticklen=-.025, xtitle='Wavenumber (k!Dx!N ; arcsec!U-1!N)', ytitle='', title='Filtered spatial FFT', dmin=MIN(spatial_fft_map.data,/nan)+1., dmax=MAX(spatial_fft_map.data,/nan)-1., position=[x5, y3, x6, y4], /noerase
    PLOTS, [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], [0, 0], line=2, thick=2, color=255
    PLOTS, [0, 0], [MIN(spatial_frequencies,/nan), MAX(spatial_frequencies,/nan)], line=2, thick=2, color=255
    PLOT, temporal_frequencies*1000., ABS(temporal_fft), /ylog, xst=1, charsize=1, xticklen=-.026, yticklen=-.011, xtitle='Frequency (mHz)', ytitle='Power (arb. units)', position=[x1+0.05, y1, x6, y2], /noerase
    temporal_fft_plot_ymin = 10^MIN(!y.crange,/nan)
    temporal_fft_plot_ymax = 10^MAX(!y.crange,/nan)
    PLOTS, [0, 0], [temporal_fft_plot_ymin, temporal_fft_plot_ymax], line=2, thick=2, color=0
    LOADCT,39,/silent
    OPLOT, temporal_frequencies*1000., (temporal_filter)>temporal_fft_plot_ymin, line=2, color=55, thick=2
    OPLOT, temporal_frequencies*1000., (ABS(temporal_fft * temporal_filter))>temporal_fft_plot_ymin, line=0, color=254, thick=2
    LOADCT,5,/silent
    WAIT, 0.5
ENDIF

; APPLY THE GAUSSIAN FILTERS TO THE DATA TO PREVENT ALIASING
FOR i = 0, (zsize_cube-1) DO threedft[*,*,i] = REFORM(threedft[*,*,i]) * spatial_ring_filter
FOR x = 0, (xsize_cube-1) DO BEGIN 
    FOR y = 0, (ysize_cube-1) DO BEGIN 
        threedft[x,y,*] = REFORM(threedft[x,y,*]) * temporal_filter
    ENDFOR
ENDFOR

; ALSO NEED TO ENSURE THE threedft ALIGNS WITH THE OLD FREQUENCY AXES USED BY THE /center CALL
IF N_ELEMENTS(temporal_frequencies_orig) MOD 2 EQ 0 THEN BEGIN
    FOR x = 0, (xsize_cube - 1) DO BEGIN
        FOR y = 0, (ysize_cube - 1) DO threedft[x, y, *] = SHIFT(REFORM(threedft[x,y,*]), 1)
    ENDFOR
ENDIF
IF N_ELEMENTS(spatial_frequencies_orig) MOD 2 EQ 0 THEN BEGIN
    FOR z = 0, (zsize_cube - 1) DO threedft[*, *, z] = SHIFT(REFORM(threedft[*,*,z]), [1, 1])
ENDIF

new_cube = REAL_PART(FFT(threedft, 1, /double, /center))

LOADCT,0, /silent

filtered_cube = new_cube

PRINT
if (mode eq 0) then print,' mode = 0: log(power)'
if (mode eq 1) then print,' mode = 1: linear power' 
if (mode eq 2) then print,' mode = 2: sqrt(power)'

!P.Multi = 0
Cleanplot, /Silent

print, ''
print, 'COMPLETED!'
print,''

END