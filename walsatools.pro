;+
; NAME: WaLSAtools
;
; PURPOSE:  
;   Performing various analysis techniques on time-series (1D signal or [x,y,t] cube)
;           Methods:
;           (1) 1D analysis with: FFT (Fast Fourier Transform), Lomb-Scargle, 
;                                 Wavelet, or HHT (Hilbert-Huang Transform)
;           (2) 3D analysis: k-ω (with optional Fourier filtering) or B-ω diagrams
; 
; CALLING SEQUENCE:
;   IDL> WaLSAtools
;   Type WaLSAtools in IDL for further information (and all keywords)
;
; Documentation: www.WaLSA.tools
; GitHub repository: www.github.com/WaLSAteam/WaLSAtools
; © WaLSA Team (www.WaLSA.team)
;-

pro walsatools,$
; (1) 1D analysis with: FFT, Wavelet, Long-Scargle, EMD, or HHT:
data=data,time=time,$ ; main inputs
power=power, frequencies=frequencies, significance=significance, coicube=coicube,$ ; main (additional) outputs
fft=fft, lombscargle=lombscargle, wavelet=wavelet, hht=hht,$ ; type of analysis
padding=padding, apod=apod, noapod=noapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
siglevel=siglevel, nperm=nperm, nosignificance=nosignificance,$ ; significance-level parameters
mother=mother, dj=dj, global=global, insideCOI=insideCOI, colornoise=colornoise,$ ; Wavelet parameters/options
stdlimit=stdlimit, nfilter=nfilter, emd=emd, imf=imf, instantfreq=instantfreq,$ ; HHT parameters/options
mode=mode,$ ; power calibration
; + keywords/options for 
; (2) 2D analysis: k-omega diagram:
arcsecpx=arcsecpx, cadence=cadence, $ ; additional main input
wavenumber=wavenumber, filtered_cube=filtered_cube, $ ; main (additional) outputs
filtering=filtering, f1=f1, f2=f2, k1=k1, k2=k2, spatial_torus=spatial_torus, temporal_torus=temporal_torus, $ ; filtering options
no_spatial_filt=no_spatial_filt, no_temporal_filt=no_temporal_filt, $
clt=clt, koclt=koclt, threemin=threemin, fivemin=fivemin, xlog=xlog, ylog=ylog, xrange=xrange, yrange=yrange, $ ; plotting keywords
epsfilename=epsfilename, noy2=noy2, nox2=nox2, smooth=smooth , savefits=savefits, filename=filename, $
; (2) 2D analysis: B-omega diagram:
Bmap=Bmap, binsize=binsize, Barray=Barray, silent=silent, bomega=bomega, komega=komega, help=help, $
normalizedbins=normalizedbins, xtickinterval=xtickinterval, version=version
;-----------------------------------------------------------------------------------------------------------------------------------        
    PRINT, ' '
    PRINT, '    __          __          _          _____            '
    PRINT, '    \ \        / /         | |        / ____|     /\    '
    PRINT, '     \ \  /\  / /  ▄▄▄▄▄   | |       | (___      /  \   '
    PRINT, '      \ \/  \/ /   ▀▀▀▀██  | |        \___ \    / /\ \  '
    PRINT, '       \  /\  /   ▄██▀▀██  | |____    ____) |  / ____ \ '
    PRINT, '        \/  \/    ▀██▄▄██  |______|  |_____/  /_/    \_\'
    PRINT, ' '
    PRINT, ' '
    PRINT, '  © WaLSA Team (www.WaLSA.team)'
    PRINT, ' -----------------------------------------------------------------------------------'
    PRINT, '  WaLSAtools v1.0'
    PRINT, '  Documentation: www.WaLSA.tools'
    PRINT, '  GitHub repository: www.github.com/WaLSAteam/WaLSAtools'
    PRINT, ' -----------------------------------------------------------------------------------'

if keyword_set(cadence) or keyword_set(time) then temporalinfo = 1 else temporalinfo = 0
if keyword_set(data) and temporalinfo eq 1 then begin
    if keyword_set(fft) or keyword_set(wavelet) or keyword_set(lombscargle) or $
       keyword_set(hht) or keyword_set(komega) or keyword_set(bomega) $
    then help = 0 else help = 1
endif else help = 1

if help then begin
    PRINT,'  Performing various analysis techniques on time-series (1D signal or [x,y,t] cube)'
    PRINT,'  Methods: 
    PRINT,'  (1) 1D analysis with: FFT (Fast Fourier Transform), Lomb-Scargle,'
    PRINT,'                        Wavelet, or HHT (Hilbert-Huang Transform)'
    PRINT,'  (2) 3D analysis: k-ω (with optional Fourier filtering) or B-ω diagrams'
    PRINT,' -----------------------------------------------------------------------------------'
    if keyword_set(version) then begin
        PRINT
        return
    endif
    type = ' '
    READ, type, PROMPT=' -- Method (enter the option 1 or 2): '
    while type lt 1 or type gt 2 do begin
        READ, type, PROMPT=' -- Please enter 1 or 2 (i.e., one of the methods listed above): '
        if type eq 1 or type eq 2 then break
    endwhile
    PRINT
    if type eq 1 then begin
        PRINT,' ----------------------------------------------------------------------'
        PRINT,' --- 1D analysis with: (1) FFT, (2) Wavelet, (3) Lomb-Scargle, (4) HHT'
        PRINT,' ----------------------------------------------------------------------'
        m1type = ' '
        READ, m1type, PROMPT=' --- Type of analysis (enter the option 1-4): '
        while m1type lt 1 or m1type gt 4 do begin
            READ, m1type, PROMPT=' --- Please enter a number between 1 and 4: '
            if m1type eq 1 or m1type eq 2 or m1type eq 3 or m1type eq 4 then break
        endwhile
        PRINT
        if m1type eq 1 then begin
            PRINT,' ---------------------------'
            PRINT,' ---- 1D analysis with FFT:'
            PRINT,' ---------------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /fft, data=data, time=time, power=p, frequencies=f, significance=signif'
        endif
        if m1type eq 2 then begin
            PRINT,' -------------------------------'
            PRINT,' ---- 1D analysis with Wavelet:'
            PRINT,' -------------------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /wavelet, data=data, time=time, power=p, frequencies=f, significance=signif'
        endif
        if m1type eq 3 then begin
            PRINT,' ------------------------------------'
            PRINT,' ---- 1D analysis with Lomb-Scargle:'
            PRINT,' ------------------------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /lomb, data=data, time=time, power=p, frequencies=f, significance=signif'
        endif
        if m1type eq 4 then begin
            PRINT,' ---------------------------'
            PRINT,' ---- 1D analysis with HHT:'
            PRINT,' ---------------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /hht, data=data, time=time, power=p, frequencies=f, significance=signif'
        endif
            PRINT       
            PRINT,' + INPUTS:'
            PRINT,'   data:            1D time series, or [x,y,t] datacube'
            PRINT,'   time:            observing times in seconds (1D array)'
            PRINT
            PRINT,' + OPTIONAL KEYWORDS:'
            ; ----padding and apodization parameters----
            PRINT,'   padding:         oversampling factor: zero padding (default: 1)'
            PRINT,'   apod:            extent of apodization edges of a Tukey window (default: 0.1)'
            PRINT,'   noapod:          if set, neither detrending nor apodization is performed!'
            PRINT,'   pxdetrend:       subtract linear trend with time per pixel. options: 1 = , 2 = '
            PRINT,'   meandetrend:     if set, subtract linear trend with time for the image means'
            ; ----significance-level parameters----
            PRINT,'   siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)'
            PRINT,'   nperm:           number of random permutations for the significance test (default: 1000)'
            PRINT,'   nosignificance:  if set, no significance level is calculated'
            ; ----power calibration----
            PRINT,'   mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
            if m1type eq 2 then begin
            PRINT,'   mother:          wavelet function (also depends on param). default: Morlet'
            PRINT,'                    other available functions: Paul and DOG are available'
            PRINT,'   param:           optional mother wavelet parameter'
            PRINT,'                    (default: 6 (for Morlet), 4 (for Paul), 2 (for DOG; i.e., Mexican-hat)'
            PRINT,'   dj:              spacing between discrete scales. default: 0.025'
            PRINT,'   global:          returns global wavelet spectrum (integrated over frequency domain)'
            PRINT,'   insideCOI:       global wavelet spectrum excluding regions influenced by COI'
            PRINT,'   colornoise:      if set, noise background is based on Auchère+2017, ApJ, 838, 166'
            endif
            if m1type eq 4 then begin
            PRINT,'   stdlimit:        standard deviation to be achieved before accepting an IMF (default: 0.2)'
            PRINT,'   nfilter:         Hanning window width for two dimensional spectrum smoothing (default: 3)'
            PRINT,'                    (an odd integer equal to or larger than 3; 0: to avoid the windowing)'
            PRINT,'   emd:             if set, intrinsic mode functions (IMFs) and their associated frequencies'
            PRINT,'                    (i.e., instantaneous frequencies) can be outputted'
            endif
            PRINT
            PRINT,' + OUTPUTS:'
            PRINT,'   power:           1D (or 3D; same dimension as input data) array of power'
            PRINT,'                    2D (or 4D) array for wavelet spectrum'
            PRINT,'                    (in DN^2/mHz, i.e., normalized to frequency resolution)'
            PRINT,'   frequencies:     1D array of frequencies (in mHz)'
            PRINT,'   significance:    significance array (same size and units as power)'
            if m1type eq 4 then begin
            PRINT,'   imf:             intrinsic mode functions (IMFs) from EMD alalysis, if emd is set'
            PRINT,'   instantfreq:     instantaneous frequencies of each component time series, if emd is set'
            endif
            if m1type eq 2 then begin
            PRINT,'   coicube:         cone-of-influence cube (when global or insideCOI are not set)'
            endif
        PRINT,' ---------------------------------------------------------------------------------'
        PRINT
    endif
    if type eq 2 then begin
        PRINT,' ----------------------------------'
        PRINT,' --- 3D analysis: (1) k-ω, (2) B-ω'
        PRINT,' ----------------------------------'
        m2type = ' '
        READ, m2type, PROMPT=' --- Type of analysis (enter the option 1 or 2): '
        while m2type lt 1 or m2type gt 2 do begin
            READ, m2type, PROMPT=' --- Please enter 1 or 2: '
            if m2type eq 1 or m2type eq 2 then break
        endwhile
        PRINT
        if m2type eq 1 then begin
            PRINT,' ----------------------'
            PRINT,' ---- 3D analysis: k-ω'
            PRINT,' ----------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /komega, data=data, time=time, arcsecpx=arcsecpx, power=p, frequencies=f, wavenumber=k'
            PRINT
            PRINT,' + INPUTS:'
            PRINT,'   data:            [x,y,t] datacube'
            PRINT,'                    [!] note: at present the input datacube needs to have identical x and y dimensions.'
            PRINT,'                    if not supplied like this the datacube will be cropped accordingly.'
            PRINT,'   cadence:         delta time between successive frames (in seconds)'
            PRINT,'   time:            observing times in seconds (1D array). It is ignored if cadence is provided'
            PRINT,'   arcsecpx:        pixel size (spatial sampling) in arcsec; a float number'
            PRINT
            PRINT,' + OPTIONAL KEYWORDS:'     
            ; ----filtering options----
            PRINT,'   filtering:       if set, filtering is proceeded'
            PRINT,'   f1:              lower frequency to filter - given in mHz'
            PRINT,'   f2:              upper frequency to filter - given in mHz'
            PRINT,'   k1:              lower wavenumber to filter - given in mHz'
            PRINT,'   k2:              upper wavenumber to filter - given in arcsec^-1'
            PRINT,'   spatial_torus:   if equal to zero, the annulus used for spatial filtering will not have a Gaussian-shaped profile'
            PRINT,'   temporal_torus:  if equal to zero, the temporal filter will not have a Gaussian-shaped profile'
            PRINT,'   no_spatial:      if set, no spatial filtering is performed'
            PRINT,'   no_temporal:     if set, no temporal filtering is performed'
            ; ----plotting parameters----
            PRINT,'   silent:          if set, the k-ω diagram is not plotted'
            PRINT,'   clt:             color table number (IDL ctload)'
            PRINT,'   koclt:           custom color tables for k-ω diagram (currently available: 1 and 2)'
            PRINT,'   threemin:        if set, a horizontal line marks the three-minute periodicity'
            PRINT,'   fivemin:         if set, a horizontal line marks the five-minute periodicity'
            PRINT,'   xlog:            if set, x-axis (wavenumber) is plotted in logarithmic scale'
            PRINT,'   ylog:            if set, y-axis (frequency) is plotted in logarithmic scale'
            PRINT,'   xrange:          x-axis (wavenumber) range'
            PRINT,'   yrange:          y-axis (frequency) range'
            PRINT,'   nox2:            if set, 2nd x-axis (spatial size, in arcsec) is not plotted'
            PRINT,'                    (spatial size (i.e., wavelength) = (2*!pi)/wavenumber)'
            PRINT,'   noy2:            if set, 2nd y-axis (period, in sec) is not plotted'
            PRINT,'                    (p = 1000/frequency)'
            PRINT,'   smooth:          if set, power is smoothed'
            ; ----power calibration----
            PRINT,'   mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
            ; ----output options----
            PRINT,'   epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made'
            PRINT
            PRINT,' + OUTPUTS:'
            PRINT,'   power:           2D array of power in log10 scale'
            PRINT,'                    (in DN^2/mHz, i.e., normalized to frequency resolution)'
            PRINT,'   frequencies:     1D array of frequencies (in mHz)'
            PRINT,'   wavenumber:      1D array of wavenumber (in arcsec^-1)'
            PRINT,'   filtered_cube:   3D array of filtered datacube (if filtering is set)'
        endif
        if m2type eq 2 then begin
            PRINT,' ----------------------'
            PRINT,' ---- 3D analysis: B-ω'
            PRINT,' ----------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /bomega, data=data, time=time, bmap=bmap, power=p, frequencies=f, barray=b'
            PRINT
            PRINT,' + INPUTS:'
            PRINT,'   data:            [x,y,t] datacube'
            PRINT,'   time:            observing times in seconds (1D array)'
            PRINT,'   bmap:            a map of magnetic fields (in G), same [x,y] size as in datacube'
            PRINT
            PRINT,' + OPTIONAL KEYWORDS:'
            PRINT,'   binsize:         size of magnetic-field bins, over which power spectra are averaged'
            PRINT,'                    (default: 50 G)'
            PRINT,'   silent:          if set, the B-ω diagram is not plotted'
            PRINT,'   clt:             color table number (IDL ctload)'
            PRINT,'   koclt:           custom color tables for k-ω diagram (currently available: 1 and 2)'
            PRINT,'   threemin:        if set, a horizontal line marks the three-minute periodicity'
            PRINT,'   fivemin:         if set, a horizontal line marks the five-minute periodicity'
            PRINT,'   xlog:            if set, x-axis (wavenumber) is plotted in logarithmic scale'
            PRINT,'   ylog:            if set, y-axis (frequency) is plotted in logarithmic scale'
            PRINT,'   xrange:          x-axis (wavenumber) range'
            PRINT,'   yrange:          y-axis (frequency) range'
            PRINT,'   noy2:            if set, 2nd y-axis (period, in sec) is not plotted'
            PRINT,'                    (p = 1000/frequency)'
            PRINT,'   smooth:          if set, power is smoothed'
            PRINT,'   normalizedbins   if set, power at each bin is normalized to its maximum value'
            PRINT,'                    (this facilitates visibility of relatively small power)'
            PRINT,'   xtickinterval    x-asis (i.e., magnetic fields) tick intervals in G (default: 400 G)'
            ; ----power calibration----
            PRINT,'   mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
            ; ----output options----
            PRINT,'   epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made'
            PRINT
            PRINT,' + OUTPUTS:'
            PRINT,'   power:           2D array of power'
            PRINT,'                    (in DN^2/mHz, i.e., normalized to frequency resolution)'
            PRINT,'   frequencies:     1D array of frequencies (y-axis) in mHz'
            PRINT,'   barray:          1D array of magnetic fields (x-axis) in G'
        endif
        PRINT,' ---------------------------------------------------------------------------------'
        PRINT
    endif
    return
endif else PRINT
;-----------------------------------------------------------------------
ii = where(~finite(data),/null,cnull)
if cnull gt 0 then data(ii) = median(data)
if min(data) ge max(data) then begin
    PRINT, ' [!] The data does not have any (temporal) variation.'
    PRINT
    return
endif
; -----------------------------------------------------------------------
if keyword_set(fft) or keyword_set(wavelet) or keyword_set(lombscargle) or keyword_set(hht) then $
power = walsa_speclizer(data,time,$ ; main inputs
                        frequencies=frequencies, significance=significance, imf=imf, instantfreq=instantfreq,$ ; main (additional) outputs
                        fft=fft, lombscargle=lombscargle, wavelet=wavelet, hht=hht,$ ; type of analysis
                        padding=padding, apod=apod, noapod=noapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
                        siglevel=siglevel, nperm=nperm, nosignificance=nosignificance,$ ; significance-level parameters
                        mother=mother, dj=dj, global=global, coicube=coicube, insideCOI=insideCOI, colornoise=colornoise,$ ; Wavelet parameters/options
                        stdlimit=stdlimit, nfilter=nfilter, emd=emd,$ ; HHT parameters/options
                        mode=mode) ; power calibration
;-----------------------------------------------------------------------
if keyword_set(komega) then $
walsa_qub_queeff, data, arcsecpx, cadence=cadence, time=time,$
                        power=power, wavenumber=wavenumber, frequencies=frequencies, filtered_cube=filtered_cube, $ ; main (additional) outputs
                        filtering=filtering, f1=f1, f2=f2, k1=k1, k2=k2, spatial_torus=spatial_torus, temporal_torus=temporal_torus, $ ; filtering options
                        no_spatial_filt=no_spatial_filt, no_temporal_filt=no_temporal_filt, $
                        clt=clt, koclt=koclt, threemin=threemin, fivemin=fivemin, xlog=xlog, ylog=ylog, xrange=xrange, yrange=yrange, $ ; plotting keywords
                        epsfilename=epsfilename, noy2=noy2, nox2=nox2, smooth=smooth, silent=silent, mode=mode
;-----------------------------------------------------------------------
if keyword_set(bomega) then $
walsa_bomega, data, Bmap, cadence=cadence, time=time, binsize=binsize, power=power, frequencies=frequencies, Barray=Barray, $
                        silent=silent, clt=clt, koclt=koclt, threemin=threemin, fivemin=fivemin, xlog=xlog, ylog=ylog, $ ; plotting keywords
                        xrange=xrange, yrange=yrange, epsfilename=epsfilename, noy2=noy2, smooth=smooth, normalizedbins=normalizedbins, $
                        xtickinterval=xtickinterval, mode=mode
;-----------------------------------------------------------------------

end