;+
; NAME: WaLSAtools
;
; PURPOSE:  
;   Performing various wave analysis techniques on 
;           (a) Single time series (1D signal or [x,y,t] cube)
;               Methods:
;               (1) 1D analysis with: FFT (Fast Fourier Transform), Wavelet, 
;                                     Lomb-Scargle, or HHT (Hilbert-Huang Transform)
;               (2) 3D analysis: k-ω (with optional Fourier filtering) or B-ω diagrams
;           
;           (b) Two time series (cross correlations between two signals)
;               With: FFT (Fast Fourier Transform), ,
;                     Lomb-Scargle, or HHT (Hilbert-Huang Transform
;
; CALLING SEQUENCE:
;   IDL> WaLSAtools 
;   Type WaLSAtools in IDL for further information (and all keywords)
;
; Documentation and info: www.WaLSA.tools
; GitHub repository: www.github.com/WaLSAteam/WaLSAtools
; © WaLSA Team (www.WaLSA.team)
; Please see www.WaLSA.tools/license & www.WaLSA.tools/citation if you use WaLSAtools
;-

pro walsatools,$
; (1) 1D analysis with: FFT, Wavelet, Long-Scargle, EMD, or HHT: 
signal=signal,time=time,$ ; main inputs
power=power, frequencies=frequencies, significance=significance, coi=coi, averagedpower=averagedpower,$ ; main (additional) outputs
fft=fft, lombscargle=lombscargle, wavelet=wavelet, hht=hht,$ ; type of analysis
padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
polyfit=polyfit,meantemporal=meantemporal,recon=recon,$
siglevel=siglevel, nperm=nperm, nosignificance=nosignificance,$ ; significance-level parameters
mother=mother, param=param, dj=dj, global=global, oglobal=oglobal, sensible=sensible, colornoise=colornoise,$ ; Wavelet parameters/options
stdlimit=stdlimit, nfilter=nfilter, emd=emd, imf=imf, instantfreq=instantfreq,$ ; HHT parameters/options
mode=mode,$ ; power calibration
dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,$ ; dominant frequency
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
normalizedbins=normalizedbins, xtickinterval=xtickinterval, version=version, plot=plot, log=log, removespace=removespace, $
data1=data1, data2=data2, phase_angle=phase_angle, coherence=coherence, cospectrum=cospectrum, amplitude=amplitude, $ ; cross spectra analysis
signif_coh=signif_coh, signif_cross=signif_cross, coh_global=coh_global, phase_global=phase_global, cross_global=cross_global, $
coh_oglobal=coh_oglobal, phase_oglobal=phase_oglobal, cross_oglobal=cross_oglobal, $
pownormal=pownormal, arrowdensity=arrowdensity, arrowsize=arrowsize, arrowheadsize=arrowheadsize, noarrow=noarrow, $
n_segments=n_segments, d1_power=d1_power, d2_power=d2_power, period=period
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
if keyword_set(signal) and temporalinfo then begin
    if keyword_set(fft) or keyword_set(wavelet) or keyword_set(lombscargle) or $
       keyword_set(hht) or keyword_set(komega) or keyword_set(bomega) $
    then help = 0 else help = 1
endif else help = 1
if keyword_set(signal) eq 0 then begin
    if keyword_set(data1) and keyword_set(data2) and temporalinfo then begin
        if keyword_set(fft) or keyword_set(wavelet) or keyword_set(lombscargle) $
           or keyword_set(hht) then help = 0 else help = 1
    endif else help = 1
endif

if help then begin
    PRINT,'  Performing various wave analysis techniques on '
    PRINT,'  (a) Single time series (1D signal or [x,y,t] cube)'
    PRINT,'      Methods: '
    PRINT,'      (1) 1D analysis with: FFT (Fast Fourier Transform), Wavelet,'
    PRINT,'                            Lomb-Scargle, or HHT (Hilbert-Huang Transform)'
    PRINT,'      (2) 3D analysis: k-ω (with optional Fourier filtering) or B-ω diagrams'
    PRINT
    PRINT,'  (b) Two time series (cross correlations between two signals)'
    PRINT,'      With: FFT (Fast Fourier Transform), Wavelet,'
    PRINT,'            Lomb-Scargle, or HHT (Hilbert-Huang Transform)'
    PRINT,' ----------------------------------------------------------------------------'
    if keyword_set(version) then begin
        PRINT
        return
    endif
    category = ' '
    READ, category, PROMPT=' -- Category -- (enter the option a or b): '
    if category eq 'a' or category eq 'b' then goto, categories else begin
        ask:
        READ, category, PROMPT=' -- Please enter a or b (i.e., one of the categories (a) or (b) listed above): '
        if category eq 'a' or category eq 'b' then goto, categories else goto, ask
    endelse
    categories:
    PRINT
    if category eq 'a' then begin
        PRINT,' ------------------------------------------------'
        PRINT,' --- Single time-series analysis: (1) 1D, (2) 3D'
        PRINT,' ------------------------------------------------'
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
                PRINT,'   walsatools, /fft, signal=signal, time=time, power=p, frequencies=f, significance=signif'
            endif
            if m1type eq 2 then begin
                PRINT,' -------------------------------'
                PRINT,' ---- 1D analysis with Wavelet:'
                PRINT,' -------------------------------'
                PRINT,' + CALLING SEQUENCE:'
                PRINT,'   walsatools, /wavelet, signal=signal, time=time, power=p, frequencies=f, significance=signif'
            endif
            if m1type eq 3 then begin
                PRINT,' ------------------------------------'
                PRINT,' ---- 1D analysis with Lomb-Scargle:'
                PRINT,' ------------------------------------'
                PRINT,' + CALLING SEQUENCE:'
                PRINT,'   walsatools, /lomb, signal=signal, time=time, power=p, frequencies=f, significance=signif'
            endif
            if m1type eq 4 then begin
                PRINT,' ---------------------------'
                PRINT,' ---- 1D analysis with HHT:'
                PRINT,' ---------------------------'
                PRINT,' + CALLING SEQUENCE:'
                PRINT,'   walsatools, /hht, signal=signal, time=time, power=p, frequencies=f, significance=signif'
            endif
                PRINT       
                PRINT,' + INPUTS:'
                PRINT,'   signal:          1D time series, or [x,y,t] datacube'
                PRINT,'   time:            observing times in seconds (1D array)'
                PRINT
                PRINT,' + OPTIONAL KEYWORDS:'
                ; ----padding, detrending, and apodization parameters----
                PRINT,'   padding:         oversampling factor: zero padding (default: 1)'
                PRINT,'   apod:            extent of apodization edges (of a Tukey window); default 0.1'
                PRINT,'   nodetrendapod:   if set, neither detrending nor apodization is performed!'
                PRINT,'   pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2'
                PRINT,'   polyfit:         the degree of polynomial fit to the data to detrend it'
                PRINT,'                    if set, instead of linear fit this polynomial fit is performed'
                PRINT,'   meantemporal:    if set, only a very simple temporal detrending is performed by'
                PRINT,'                    subtracting the mean signal from the signal'
                PRINT,'                    i.e., the fitting procedure (linear or higher polynomial degrees) is omitted'
                PRINT,'   meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)'
                PRINT,'   recon:           optional keyword that will Fourier reconstruct the input timeseries'
                PRINT,'                    note: this does not preserve the amplitudes and is only useful when attempting'
                PRINT,'                    to examine frequencies that are far away from the -untrustworthy- low frequencies'
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
                PRINT,'   global:          returns global wavelet spectrum (time-averaged wavelet power)'
                PRINT,'   oglobal:         global wavelet spectrum excluding regions affected by CoI'
                PRINT,'   sensible:        time-integral of wavelet power excluding regions influenced by cone-of-influence'
                PRINT,'                    and only for those above the significance level'
                PRINT,'                    i.e., power-weighted frequency distribution (with significant power & unaffected by CoI)'
                PRINT,'                    Note: this is likely the most correct spectrum!'
                PRINT,'   colornoise:      if set, noise background is based on Auchère+2017, ApJ, 838, 166'
            endif
            if m1type eq 4 then begin
                PRINT,'   stdlimit:        standard deviation to be achieved before accepting an IMF (default: 0.2)'
                PRINT,'   nfilter:         Hanning window width for two dimensional spectrum smoothing (default: 3)'
                PRINT,'                    (an odd integer equal to or larger than 3; 0: to avoid the windowing)'
                PRINT,'   emd:             if set, intrinsic mode functions (IMFs) and their associated frequencies'
                PRINT,'                    (i.e., instantaneous frequencies) can be outputted'
            endif
                ; ----dominant frequency----
                PRINT,'   nodominantfreq:  if set, dominant frequency and dominant power are not calculated'
                PRINT,'                    (to, e.g., save computational time for large datasets)'
                PRINT
                PRINT,' + OUTPUTS:'
                PRINT,'   power:           1D (or 3D; same dimension as input data) array of power'
                PRINT,'                    2D (or 4D) array for wavelet spectrum'
                PRINT,'                    (in DN^2/mHz, i.e., normalised to frequency resolution)'
                PRINT,'   frequencies:     1D array of frequencies (in mHz)'
                PRINT,'   period:          1D array of periods (in seconds)'
                PRINT,'   significance:    significance array (same size and units as power)'
            if m1type eq 4 then begin
                PRINT,'   imf:             intrinsic mode functions (IMFs) from EMD analysis, if emd is set'
                PRINT,'   instantfreq:     instantaneous frequencies of each component time series, if emd is set'
            endif
            if m1type eq 2 then begin
                PRINT,'   coi:             cone-of-influence cube (when global, oglobal, or sensible are not set)'
            endif
                PRINT,'   dominantfreq:    dominant frequency, i.e., frequency corresponding to the maximum power (in mHz)'
                PRINT,'                    same spatial size as input data (i.e., 1D or 2D)'
                PRINT,'                    if there are multiple peaks with the same power, the lowest dominant frequency is returned!'
                PRINT,'   dominantpower:   power (in DN^2/mHz) corresponding to the dominant frequency'
                PRINT,'                    same spatial size as input data (i.e., 1D or 2D)'
                PRINT,'   rangefreq:       frequency range over which the dominant frequency is computed. default: full frequency range'
                PRINT,'   averagedpower:   spatially averaged power spectrum (of multiple 1D power spectra)'
                PRINT,'   amplitude:       1D array of oscillation amplitude (or a 3D array if the input is a 3D cube)'
            if m1type eq 2 then begin
                PRINT,'                    note: only for global (traditional, oglobal, or sensible) wavelet'
            endif
            PRINT,' -----------------------------------------------------------------------------------------'
            if m1type eq 1 then m1typecite='WaLSAtools: 1D analysis with FFT'
            if m1type eq 2 then m1typecite='WaLSAtools: 1D analysis with Wavelet'
            if m1type eq 3 then m1typecite='WaLSAtools: 1D analysis with Lomb-Scargle'
            if m1type eq 4 then m1typecite='WaLSAtools: 1D analysis with HHT'
            PRINT,' * CITATION:'
            PRINT,'   Please cite the following article if you use '+m1typecite
            PRINT,'   -- Jess et al. 2021, LRSP, in preparation' 
            PRINT,'      (see www.WaLSA.tools/citation)'
            PRINT,' -----------------------------------------------------------------------------------------'
            PRINT
        endif
        if type eq 2 then begin
            PRINT,' -----------------------------------'
            PRINT,' --- 3D analysis: (1) k-ω, (2) B-ω'
            PRINT,' -----------------------------------'
            m2type = ' '
            READ, m2type, PROMPT=' --- Type of analysis (enter the option 1 or 2): '
            while m2type lt 1 or m2type gt 2 do begin
                READ, m2type, PROMPT=' --- Please enter 1 or 2: '
                if m2type eq 1 or m2type eq 2 then break
            endwhile
            PRINT
            if m2type eq 1 then begin
                PRINT,' -----------------------'
                PRINT,' ---- 3D analysis: k-ω'
                PRINT,' -----------------------'
                PRINT,' + CALLING SEQUENCE:'
                PRINT,'   walsatools, /komega, signal=signal, time=time, arcsecpx=arcsecpx, power=p, frequencies=f, wavenumber=k'
                PRINT
                PRINT,' + INPUTS:'
                PRINT,'   signal:          [x,y,t] datacube'
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
                PRINT,'   clt:             colour table number (IDL ctload)'
                PRINT,'   koclt:           custom colour tables for k-ω diagram (currently available: 1 and 2)'
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
                PRINT,'                    (in DN^2/mHz, i.e., normalised to frequency resolution)'
                PRINT,'   frequencies:     1D array of frequencies (in mHz)'
                PRINT,'   wavenumber:      1D array of wavenumber (in arcsec^-1)'
                PRINT,'   filtered_cube:   3D array of filtered datacube (if filtering is set)'
            endif
            if m2type eq 2 then begin
                PRINT,' -----------------------'
                PRINT,' ---- 3D analysis: B-ω'
                PRINT,' -----------------------'
                PRINT,' + CALLING SEQUENCE:'
                PRINT,'   walsatools, /bomega, signal=signal, time=time, bmap=bmap, power=p, frequencies=f, barray=b'
                PRINT
                PRINT,' + INPUTS:'
                PRINT,'   signal:          [x,y,t] datacube'
                PRINT,'   time:            observing times in seconds (1D array)'
                PRINT,'   bmap:            a map of magnetic fields (in G), same [x,y] size as in datacube'
                PRINT
                PRINT,' + OPTIONAL KEYWORDS:'
                PRINT,'   binsize:         size of magnetic-field bins, over which power spectra are averaged'
                PRINT,'                    (default: 50 G)'
                PRINT,'   silent:          if set, the B-ω diagram is not plotted'
                PRINT,'   clt:             colour table number (IDL ctload)'
                PRINT,'   koclt:           custom colour tables for k-ω diagram (currently available: 1 and 2)'
                PRINT,'   threemin:        if set, a horizontal line marks the three-minute periodicity'
                PRINT,'   fivemin:         if set, a horizontal line marks the five-minute periodicity'
                PRINT,'   xlog:            if set, x-axis (wavenumber) is plotted in logarithmic scale'
                PRINT,'   ylog:            if set, y-axis (frequency) is plotted in logarithmic scale'
                PRINT,'   xrange:          x-axis (wavenumber) range'
                PRINT,'   yrange:          y-axis (frequency) range'
                PRINT,'   noy2:            if set, 2nd y-axis (period, in sec) is not plotted'
                PRINT,'                    (p = 1000/frequency)'
                PRINT,'   smooth:          if set, power is smoothed'
                PRINT,'   normalizedbins   if set, power at each bin is normalised to its maximum value'
                PRINT,'                    (this facilitates visibility of relatively small power)'
                PRINT,'   xtickinterval    x-asis (i.e., magnetic fields) tick intervals in G (default: 400 G)'
                ; ----power calibration----
                PRINT,'   mode:            0 = log(power) (default), 1 = linear power, 2 = sqrt(power) = amplitude
                ; ----output options----
                PRINT,'   epsfilename:     if provided (as a string), an eps file of the k-ω diagram is made'
                PRINT
                PRINT,' + OUTPUTS:'
                PRINT,'   power:           2D array of power'
                PRINT,'                    (in DN^2/mHz, i.e., normalised to frequency resolution)'
                PRINT,'   frequencies:     1D array of frequencies (y-axis) in mHz'
                PRINT,'   barray:          1D array of magnetic fields (x-axis) in G'
            endif
            PRINT,' -----------------------------------------------------------------------------------------'
            if m2type eq 1 then m2typecite='WaLSAtools: k-ω analysis'
            if m2type eq 2 then m2typecite='WaLSAtools: B-ω analysis'
            PRINT,' * CITATION:'
            PRINT,'   Please cite the following articles if you use '+m2typecite
            PRINT,'   -- Jess et al. 2021, LRSP, in preparation' 
            if m2type eq 1 then $
            PRINT,'   -- Jess et al. 2017, ApJ, 842, 59'
            if m2type eq 2 then $
            PRINT,'   -- Stangalini et al. 2021, A&A, in press'
            PRINT,'      (see www.WaLSA.tools/citation)'
            PRINT,' -----------------------------------------------------------------------------------------'
            PRINT
        endif
    endif
    if category eq 'b' then begin
        PRINT,' -----------------------------------------------------------------------------------'
        PRINT,' --- Two time-series analysis with: (1) FFT, (2) Wavelet, (3) Lomb-Scargle, (4) HHT'
        PRINT,' -----------------------------------------------------------------------------------'
        c1type = ' '
        READ, c1type, PROMPT=' --- Type of analysis (enter the option 1-4): '
        while c1type lt 1 or c1type gt 4 do begin
            READ, c1type, PROMPT=' --- Please enter a number between 1 and 4: '
            if c1type eq 1 or c1type eq 2 or c1type eq 3 or c1type eq 4 then break
        endwhile
        PRINT
        if c1type eq 1 then begin
            PRINT,' ------------------------------------'
            PRINT,' ---- cross-power analysis with FFT:'
            PRINT,' ------------------------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /fft, data1=data1, data2=data2, time=time, $'
            PRINT,'               cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f'
        endif
        if c1type eq 2 then begin
            PRINT,' ----------------------------------------'
            PRINT,' ---- cross-power analysis with Wavelet:'
            PRINT,' ----------------------------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /wavelet, data1=data1, data2=data2, time=time, $'
            PRINT,'               cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f'
        endif
        if c1type eq 3 then begin
            PRINT,' ---------------------------------------------'
            PRINT,' ---- cross-power analysis with Lomb-Scargle:'
            PRINT,' ---------------------------------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /lomb, data1=data1, data2=data2, time=time, $'
            PRINT,'               cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f'
        endif
        if c1type eq 4 then begin
            PRINT,' -------------------------------------'
            PRINT,' ---- cross-powerD analysis with HHT:'
            PRINT,' -------------------------------------'
            PRINT,' + CALLING SEQUENCE:'
            PRINT,'   walsatools, /hht, data1=data1, data2=data2, time=time, $'
            PRINT,'               cospectrum=cospec, phase_angle=ph, coherence=coh, frequencies=f'
        endif
            PRINT       
            PRINT,' + INPUTS:'
            PRINT,'   data1:           first (1D) time series'
            PRINT,'   data2:           second (1D) time series, co-aligned with data1'
            PRINT,'   time:            observing times in seconds (1D array)'
            PRINT
            PRINT,' + OPTIONAL KEYWORDS:'
            ; ----padding, detrending, and apodization parameters----
            PRINT,'   padding:         oversampling factor: zero padding (default: 1)'
            PRINT,'   apod:            extent of apodization edges (of a Tukey window); default 0.1'
            PRINT,'   nodetrendapod:   if set, neither detrending nor apodization is performed!'
            PRINT,'   pxdetrend:       subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2'
            PRINT,'   polyfit:         the degree of polynomial fit to the data to detrend it'
            PRINT,'                    if set, instead of linear fit this polynomial fit is performed'
            PRINT,'   meantemporal:    if set, only a very simple temporal detrending is performed by'
            PRINT,'                    subtracting the mean signal from the signal'
            PRINT,'                    i.e., the fitting procedure (linear or higher polynomial degrees) is omitted'
            PRINT,'   meandetrend:     if set, subtract linear trend with time for the image means (i.e., spatial detrending)'
        if c1type ne 2 then begin    
            PRINT,'   recon:           optional keyword that will Fourier reconstruct the input timeseries'
            PRINT,'                    note: this does not preserve the amplitudes and is only useful when attempting'
            PRINT,'                    to examine frequencies that are far away from the -untrustworthy- low frequencies'
            ; ----HHT parameters/options----
            PRINT,'   stdlimit:        standard deviation to be achieved before accepting an IMF'
            PRINT,'                    (recommended value between 0.2 and 0.3; perhaps even smaller); default: 0.2'
            PRINT,'   nfilter:         Hanning window width for two dimensional smoothing of the Hilbert spectrum. default: 3 '
            PRINT,'                    (an odd integer, preferably equal to or larger than 3; equal to 0 to avoid the windowing)'
        endif
            ; ----significance-level parameters----
            PRINT,'   siglevel:        significance level (default: 0.05 = 5% significance = 95% confidence)'
            PRINT,'   nperm:           number of random permutations for the significance test (default: 50)'
            PRINT,'                    note: the default value is set for quick tests. Choose a large number'
            PRINT,'                    (e.g., 2000 or larger) for a better statistical result'
            PRINT,'   nosignificance:  if set, no significance level is calculated'
        if c1type eq 2 then begin
            ; ----wavelet parameters/options----
            PRINT,'   mother:          wavelet function (also depends on param). default: Morlet'
            PRINT,'                    other available functions: Paul and DOG are available'
            PRINT,'   param:           optional mother wavelet parameter'
            PRINT,'                    (default: 6 (for Morlet), 4 (for Paul), 2 (for DOG; i.e., Mexican-hat)'
            PRINT,'   dj:              spacing between discrete scales. default: 0.025'
            PRINT,'   colornoise:      if set, noise background is based on Auchère+2017, ApJ, 838, 166'
        endif
        if c1type eq 2 then begin
            ; ----plotting----
            PRINT,'   plot:            if set, wavelet power spectra of the two time series as well as'
            PRINT,'                    their wavelet cospectrum (cross-spectrum) and coherence, along with the'
            PRINT,'                    significance levels as contours, are plotted'
            PRINT,'                    The phase angles between the two time series are also depicted by default'
            PRINT,'                    Arrows pointing right mark zero phase (meaning in-phase oscillations),'
            PRINT,'                    arrows pointing straight up indicate data2 lags behind data1 by 90 degrees'
            PRINT,'   noarrow:         if set, the phase angles are not overplotted as arrows'
            PRINT,'   arrowdensity:    number of arrows (illustrating phase angles) in x and y directions (default: [30,18])'
            PRINT,'   arrowsize:       size of the arrows (default: 1)'
            PRINT,'   arrowheadsize:   size of the arrows head (default: 1)'
            PRINT,'   pownormal:       if set, the power is normalised to its maximum value'
            PRINT,'   log:             if set, the power spectra and the cospectrum are plotted in log10 scale'
            PRINT,'   removespace:     if set, the time-period areas affected by the CoI over the entire time range are not plotted'
            PRINT,'   clt:             colour table number (idl ctload)'
            PRINT,'   koclt:           custom colour tables (currently available: 1 and 2)'
        endif
            PRINT
            PRINT,' + OUTPUTS:'
        if c1type eq 2 then begin
            PRINT,'   cospectrum:      absolute values of the cross power'
            PRINT,'                    (2D array for wavelet spectrum; 1D for global, oglobal, or sensible spectrum)'
            PRINT,'   coherence:       wavelet coherence (same size as cospectrum)'
            PRINT,'   phase_angle:     phase angles in degrees (same size as cospectrum)'
            PRINT,'   frequency:       1D array of frequencies (in mHz)'
            PRINT,'   signif_cross:    significance map for the cospectrum (same size as cospectrum)'
            PRINT,'   scale:           the scale vector of scale indices, given by the overlap of scale1 and scale2'
            PRINT,'                    cospectrum/signif_coh indicates regions above the siglevel'
            PRINT,'   signif_coh:      significance map for the coherence (same size as cospectrum)'
            PRINT,'                    coherence/signif_coh indicates regions above the siglevel'
            PRINT,'   coi:             the vector of the cone-of-influence'
            PRINT,'   coh_global:      global coherence averaged over all times'
            PRINT,'   phase_global:    global phase averaged over all times'
            PRINT,'   cross_global:    global cross wavelet averaged over all times'
            PRINT,'   coh_oglobal:     global coherence averaged over all times excluding areas affected by CoI'
            PRINT,'   phase_oglobal:   global phase averaged over all times excluding areas affected by CoI'
            PRINT,'   cross_oglobal:   global cross wavelet averaged over all times excluding areas affected by CoI'
        endif
        if c1type ne 2 then begin
            PRINT,'   cospectrum:      absolute values of the cross power (1D array)'
            PRINT,'   coherence:       coherence (1D array)'
            PRINT,'   phase_angle:     phase angles in degrees (1D array)'
            PRINT,'   frequency:       1D array of frequencies (in mHz)'
            PRINT,'   signif_cross:    significance levels for the cospectrum (1D array)'
            PRINT,'   signif_coh:      significance levels for the coherence (1D array)'
        endif
        PRINT,' -----------------------------------------------------------------------------------------'
        if c1type eq 1 then c1typecite='WaLSAtools: cross-correlation analysis with FFT'
        if c1type eq 2 then c1typecite='WaLSAtools: cross-correlation analysis with Wavelet'
        if c1type eq 3 then c1typecite='WaLSAtools: cross-correlation analysis with Lomb-Scargle'
        if c1type eq 4 then c1typecite='WaLSAtools: cross-correlation analysis with HHT'
        PRINT,' * CITATION:'
        PRINT,'   Please cite the following article if you use '+c1typecite
        PRINT,'   -- Jess et al. 2021, LRSP, in preparation' 
        PRINT,'      (see www.WaLSA.tools/citation)'
        PRINT,' -----------------------------------------------------------------------------------------'
        PRINT
    endif
    return
endif else PRINT
;-----------------------------------------------------------------------
if keyword_set(signal) then begin
    ii = where(~finite(signal),/null,cnull)
    if cnull gt 0 then signal(ii) = median(signal)
    if min(signal) ge max(signal) then begin
        PRINT, ' [!] The signal does not have any (temporal) variation.'
        PRINT
        return
    endif
; -----------------------------------------------------------------------
if keyword_set(fft) or keyword_set(wavelet) or keyword_set(lombscargle) or keyword_set(hht) then $
power = walsa_speclizer(signal,time,$ ; main inputs
                        frequencies=frequencies, significance=significance, imf=imf, instantfreq=instantfreq,averagedpower=averagedpower,period=period,$ ; main (additional) outputs
                        fft=fft, lombscargle=lombscargle, wavelet=wavelet, hht=hht,$ ; type of analysis
                        padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
                        polyfit=polyfit,meantemporal=meantemporal,recon=recon,$
                        siglevel=siglevel, nperm=nperm, nosignificance=nosignificance,$ ; significance-level parameters
                        mother=mother, param=param, dj=dj, global=global, coi=coi, oglobal=oglobal, sensible=sensible, colornoise=colornoise,$ ; Wavelet parameters/options
                        stdlimit=stdlimit, nfilter=nfilter, emd=emd,$ ; HHT parameters/options
                        mode=mode,silent=silent,$ ; power calibration
                        dominantfreq=dominantfreq,rangefreq=rangefreq,nodominantfreq=nodominantfreq,dominantpower=dominantpower,amplitude=amplitude) ; dominant frequency
;-----------------------------------------------------------------------
if keyword_set(komega) then $
walsa_qub_queeff, signal, arcsecpx, cadence=cadence, time=time,$
                        power=power, wavenumber=wavenumber, frequencies=frequencies, filtered_cube=filtered_cube, $ ; main (additional) outputs
                        filtering=filtering, f1=f1, f2=f2, k1=k1, k2=k2, spatial_torus=spatial_torus, temporal_torus=temporal_torus, $ ; filtering options
                        no_spatial_filt=no_spatial_filt, no_temporal_filt=no_temporal_filt, $
                        clt=clt, koclt=koclt, threemin=threemin, fivemin=fivemin, xlog=xlog, ylog=ylog, xrange=xrange, yrange=yrange, $ ; plotting keywords
                        epsfilename=epsfilename, noy2=noy2, nox2=nox2, smooth=smooth, silent=silent, mode=mode
;-----------------------------------------------------------------------
if keyword_set(bomega) then $
walsa_bomega, signal, Bmap, cadence=cadence, time=time, binsize=binsize, power=power, frequencies=frequencies, Barray=Barray, $
                        silent=silent, clt=clt, koclt=koclt, threemin=threemin, fivemin=fivemin, xlog=xlog, ylog=ylog, $ ; plotting keywords
                        xrange=xrange, yrange=yrange, epsfilename=epsfilename, noy2=noy2, smooth=smooth, normalizedbins=normalizedbins, $
                        xtickinterval=xtickinterval, mode=mode
endif
;-----------------------------------------------------------------------
if keyword_set(data1) and keyword_set(data2) then begin
    ii = where(~finite(data1),/null,cnull) & if cnull gt 0 then data1(ii) = median(data1)
    ii = where(~finite(data2),/null,cnull) & if cnull gt 0 then data2(ii) = median(data2)
    if keyword_set(fft) or keyword_set(lombscargle) or keyword_set(hht) then $
    walsa_cross_spectrum, data1=data1, data2=data2, time=time, phase_angle=phase_angle, coherence=coherence, frequencies=frequencies, cospectrum=cospectrum, $
                        fft=fft, lombscargle=lombscargle, hht=hht,$ ; type of analysis
                        padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$ ; padding and apodization parameters
                        polyfit=polyfit,meantemporal=meantemporal,recon=recon,$
                        stdlimit=stdlimit, nfilter=nfilter, $ ; HHT parameters/options
                        nosignificance=nosignificance, signif_coh=signif_coh, signif_cross=signif_cross, n_segments=n_segments, d1_power=d1_power, d2_power=d2_power
    if keyword_set(wavelet) then $
    walsa_wavelet_cross_spectrum, data1,data2,time, $  ; main inputs
                        mother=mother, param=param, dj=dj, colornoise=colornoise, $
                        coherence=coherence,phase_angle=phase_angle, $
                        scale=scale,coi=coi, $
                        coh_global=coh_global, phase_global=phase_global, cross_global=cross_global, $
                        coh_oglobal=coh_oglobal, phase_oglobal=phase_oglobal, cross_oglobal=cross_oglobal, $
                        cospectrum=cospectrum, period=period, $
                        frequency=frequency,signif_coh=signif_coh,signif_cross=signif_cross, $
                        padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$
                        polyfit=polyfit,meantemporal=meantemporal,$
                        nosignificance=nosignificance,pownormal=pownormal,siglevel=siglevel, $
                        plot=plot,clt=clt,log=log,nperm=nperm,removespace=removespace,koclt=koclt,$
                        arrowdensity=arrowdensity,arrowsize=arrowsize,arrowheadsize=arrowheadsize,noarrow=noarrow
    return
endif
; ----------------------------------------------------------------------
end