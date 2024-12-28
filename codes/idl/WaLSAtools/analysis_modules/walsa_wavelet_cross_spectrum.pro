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
; NAME: WaLSA_wavelet_cross_spectrum
;       part of -- WaLSAtools --
;
; PURPOSE:
;   Compute (and optionally plot) wavelet cospectrum (cross-spectrum), coherence, and phase angles
;           between two time series as well as thier statistical significance levels.
;
; CALLING SEQUENCE:
;
;   WaLSA_wavelet_cross_spectrum, data1, time1, data2, time2, /plot
;
; + INPUTS:
;
;   data1:    first (1D) time series (evenly sampled)
;   data2:    second (1D) time series (evenly sampled), co-aligned with data1
;   time:     observing times in seconds (1D array)
;
; + OPTIONAL KEYWORDS:
;
; ----wavelet parameters/options----
;   mother:         wavelet function, providing different localisation/resolution in frequency and in time (also depends on param, m).
;                   currently, 'Morlet','Paul','DOG' (derivative of Gaussian) are available. default: 'Morlet'.
;   param:          optional mother wavelet parameter. 
;                   For 'Morlet' this is k0 (wavenumber), default is 6. 
;                   For 'Paul' this is m (order), default is 4.
;                   For 'DOG' this is m (m-th derivative), default is 2 (i.e., the real-valued Mexican-hat wavelet)
;   dj:             spacing between discrete scales. default: 0.025
;   colornoise:     if set, noise background is based on Auchère et al. 2017, ApJ, 838, 166 / 2016, ApJ, 825, 110
; ----significance-level parameters----
;   siglevel:       significance level (default: 0.05 = 5% significance level = 95% confidence level)
;   nperm:          number of random permutations for the significance test (default=50)
;                   note: the default value is set for quick tests. Choose a large number (e.g., 2000 or larger)
;                         for a better statistical result.
;   nosignificance: if set, the significance levels are calculated.
;                   (thus not overplotted as contours when plot option is set)
; ----padding, detrending, and apodization parameters----
;   padding:        oversampling factor: zero padding (increasing timespan) to increase frequency resolution (NOTE: doesn't add information)
;   apod:           extent of apodization edges (of a Tukey window); default 0.1
;   nodetrendapod:  if set, neither detrending nor apodization is performed!
;   pxdetrend:      subtract linear trend with time per pixel. options: 1=simple, 2=advanced; default: 2
;   polyfit:        the degree of polynomial fit to the data to detrend it.
;                   if set, instead of linear fit this polynomial fit is performed.
;   meantemporal:   if set, only a very simple temporal detrending is performed by subtracting the mean signal from the signal.
;                   i.e., the fitting procedure (linear or higher polynomial degrees) is omitted.
;   meandetrend:    if set, subtract linear trend with time for the image means (i.e., spatial detrending)
; ----plotting----
;   plot:           if set, wavelet power sepctra of the two time series as well as 
;                   their wavelet cospectrum (cross-spectrum) and coherence, along with the 
;                   significance levels as contours, are plotted.
;                   The phase angles between the two time series are also depicted by default. 
;                   Arrows pointing right mark zero phase (meaning in-phase oscillations),
;                   arrows pointing straight up indicate data2 lags behind data1 by 90 degrees.
;   noarrow:        if set, the phase angles are not overplotted as arrows.
;   arrowdensity:   number of arrows (iluustrating phase angles) in x and y directions (default: [30,18])
;   arrowsize:      size of the arrows (default: 1)
;   arrowheadsize:  size of the arrows' head (default: 1)
;   pownormal:      if set, the power is normalised to its maximum value
;   log:            if set, the power spectra and the cospectrum are plotted in log10 scale
;   removespace:    if set, the time-period areas affected by the coi over the entire time range are not plotted.
;   clt:            color table number (idl ctload)
;   koclt:          custom color tables (currently available: 1 and 2)
;
; + OUTPUTS:
;
;   cospectrum:             absolute values of the cross wavelet map
;   coherence:              wavelet coherence map, as a function of time and scale
;   phase_angle:            phase angles in degrees 
;   time:                   time vector, given by the overlap of time1 and time2 
;                           (it is not used: it is assumed the two time series are temporally aligned)
;   frequency:              the frequency vector; in mHz
;   scale:                  scale vector of scale indices, given by the overlap of scale1 and scale2 
;                           computed by WaLSA_wavelet.pro
;   coi:                    vector of the cone-of-influence
;   signif_coh:             significance map for the coherence (same 2D size as the coherence map)
;                           coherence/signif_coh indicates regions above the siglevel
;   signif_cross:           significance map for the cospectrum (same 2D size as the cospectrum map)
;                           cospectrum/signif_coh indicates regions above the siglevel
;   coh_global:             global (or mean) coherence averaged over all times
;   phase_global:           global (or mean) phase averaged over all times
;   cross_global:           global (or mean) cross wavelet averaged over all times
;   coh_oglobal:            global (or mean) coherence averaged over all times, excluding areas affected by COI (oglobal)
;   phase_oglobal:          global (or mean) phase averaged over all times, excluding areas affected by COI (oglobal)
;   cross_oglobal:          global (or mean) cross wavelet averaged over all times, excluding areas affected by COI (oglobal)
;;----------------------------------------------------------------------------
; This routine is originally based on WAVE_COHERENCY.pro
; Copyright (C) 1998-2005, Christopher Torrence
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made. This
; routine is provided as is without any express or
; implied warranties whatsoever.
;
; Reference: Torrence, C. and P. J. Webster, 1999: Interdecadal changes in the
;            ENSO-monsoon system. <I>J. Climate</I>, 12, 2679-2690.
;;----------------------------------------------------------------------------
; Largely modified/extended by Shahin Jafarzadeh 2016-2021
;-

function walsa_getcorss_spectrum_wavelet, $
         data1,time1,data2,time2, $
         mother=mother, param=param, dj=dj, colornoise=colornoise,$
         coherence=coherence,phase_angle=phase_angle, $
         time_out=time_out,scale_out=scale_out,coi_out=coi_out, $
         cross_wavelet=cross_wavelet,power1=power1,power2=power2, $
         frequency=frequency,period=period,silent=silent, $
         coh_global=coh_global, phase_global=phase_global, cross_global=cross_global, $
         coh_oglobal=coh_oglobal, phase_oglobal=phase_oglobal, cross_oglobal=cross_oglobal, $
         nosignificance=nosignificance,removespace=removespace, $
         nodetrendapod=nodetrendapod,log=log,plot=plot,clt=clt,koclt=koclt,$
         padding=padding,apod=apod,pxdetrend=pxdetrend,meandetrend=meandetrend,$
         polyfit=polyfit,meantemporal=meantemporal
         
    dt1 = walsa_mode(walsa_diff(time1))
    wave1 = walsa_wavelet(data1,dt1,scale=scale1,nodetrendapod=nodetrendapod,PERIOD=period,COI=coi1,plot=plot,w=4,log=log,silent=silent,$
                          removespace=removespace,koclt=koclt,clt=clt,mother=mother, param=param, dj=dj, colornoise=colornoise)

    frequency = 1000./period ; in mHz
    nf = n_elements(frequency)
    
    dt2 = walsa_mode(walsa_diff(time2))
    wave2 = walsa_wavelet(data2,dt2,scale=scale2,nodetrendapod=nodetrendapod,plot=plot,w=5,log=log,silent=silent,removespace=removespace,koclt=koclt,$
                          clt=clt,mother=mother, param=param, dj=dj, colornoise=colornoise)
	
;*** find overlapping times
    time_start = MIN(time1) > MIN(time2)
    time_end = MAX(time1) < MAX(time2)
    time1_start = MIN(WHERE((time1 ge time_start)))
    time1_end = MAX(WHERE((time1 le time_end)))
    time2_start = MIN(WHERE((time2 ge time_start)))
    time2_end = MAX(WHERE((time2 le time_end)))

;*** find overlapping scales
    scale_start = MIN(scale1) > MIN(scale2)
    scale_end = MAX(scale1) < MAX(scale2)
    scale1_start = MIN(WHERE((scale1 ge scale_start)))
    scale1_end = MAX(WHERE((scale1 le scale_end)))
    scale2_start = MIN(WHERE((scale2 ge scale_start)))
    scale2_end = MAX(WHERE((scale2 le scale_end)))
    
    period = period(scale1_start:scale1_end)

;*** cross wavelet & individual wavelet power
    cross_wavelet = wave1(time1_start:time1_end,scale1_start:scale1_end)*CONJ(wave2(time2_start:time2_end,scale2_start:scale2_end))    
    power1 = ABS(wave1(time1_start:time1_end,scale1_start:scale1_end))^2
    power2 = ABS(wave2(time2_start:time2_end,scale2_start:scale2_end))^2
    
    dt = dt1
    ntime = time1_end - time1_start + 1
    nj = scale1_end - scale1_start + 1
    if (N_EleMENTS(dj) le 0) then dj = ALOG(scale1(1)/scale1(0))/ALOG(2)
    scale = scale1(scale1_start:scale1_end)
    time_out = time1(time1_start:time1_end)
    scale_out = scale1(scale1_start:scale1_end)
    if (N_EleMENTS(coi1) EQ N_EleMENTS(time1)) then $
        coi_out = coi1(time1_start:time1_end)
    
    nt = n_elements(time_out)

; calculate global cross-power, coherency, and phase angle
; global wavelet is the time average of the wavelet spectrum
    global1 = TOTAL(power1,1,/nan)/nt
    global2 = TOTAL(power2,1,/nan)/nt
    cross_global = TOTAL(cross_wavelet,1)/nt
    coh_global = ABS(cross_global)^2/(global1*global2)
    phase_global = reform(ATAN(IMAGINARY(cross_global),REAL_PART(cross_global)))*(180./!pi)
    
    global1 = global1;/frequency[nf-1] ; in DN^2
    global2 = global2;/frequency[nf-1] ; in DN^2
    cross_global = ABS(cross_global);/frequency[nf-1] ; in DN^2

; calculate global cross-power, coherency, and phase angle excluding areas affected by COI (oglobal)
    oglobal_power1 = fltarr(nt,nf)
    oglobal_power2 = fltarr(nt,nf)
    oglobal_cross_wavelet = fltarr(nt,nf)
    for i=0L, nt-1 do begin
        ii = where(reform(period) lt coi_out[i], pnum)
        oglobal_power1[i,ii] = reform(power1[i,ii])
        oglobal_power2[i,ii] = reform(power2[i,ii])
        oglobal_cross_wavelet[i,ii] = reform(cross_wavelet[i,ii])
    endfor
    oglobal_global1 = TOTAL(oglobal_power1,1,/nan)/nt 
    oglobal_global2 = TOTAL(oglobal_power2,1,/nan)/nt 
    cross_oglobal = TOTAL(oglobal_cross_wavelet,1)/nt
    coh_oglobal = ABS(cross_oglobal)^2/(oglobal_global1*oglobal_global2)
    phase_oglobal = reform(ATAN(IMAGINARY(cross_oglobal),REAL_PART(cross_oglobal)))*(180./!pi)

    oglobal1 = oglobal_global1;/frequency[nf-1] ; in DN^2
    oglobal2 = oglobal_global2;/frequency[nf-1] ; in DN^2
    cross_oglobal = ABS(cross_oglobal);/frequency[nf-1] ; in DN^2
    
    for j=0,nj-1 do begin ;*** time-smoothing
        st1 = SYSTIME(1)
        nt = LONG(4L*scale(j)/dt)/2L*4 + 1L
        time_wavelet = (FINDgeN(nt) - nt/2)*dt/scale(j)
        wave_function = EXP(-time_wavelet^2/2.)   ;*** Morlet
        wave_function = FLOAT(wave_function/TOTAL(wave_function)) ; normalize
        nz = nt/2
        zeros = COMPleX(FltARR(nz),FltARR(nz))
        cross_wave_slice = [zeros,cross_wavelet(*,j),zeros]
        cross_wave_slice = CONVOL(cross_wave_slice,wave_function)
        cross_wavelet(*,j) = cross_wave_slice(nz:ntime+nz-1)
        zeros = FLOAT(zeros)
        power_slice = [zeros,power1(*,j),zeros]
        power_slice = CONVOL(power_slice,wave_function)
        power1(*,j) = power_slice(nz:ntime + nz - 1)
        power_slice = [zeros,power2(*,j),zeros]
        power_slice = CONVOL(power_slice,wave_function)
        power2(*,j) = power_slice(nz:ntime + nz - 1)
    endfor  ;*** time-smoothing
    
;*** normalize by scale
    scales = REBIN(TRANSPOSE(scale),ntime,nj)
    cross_wavelet = TEMPORARY(cross_wavelet)/scales
    power1 = TEMPORARY(power1)/scales
    power2 = TEMPORARY(power2)/scales
   
    nweights = FIX(0.6/dj/2 + 0.5)*2 - 1   ; closest (smaller) odd integer
    weights = REPLICATE(1.,nweights)
    weights = weights/TOTAL(weights) ; normalize
    for i=0,ntime-1 do begin ;*** scale-smoothing
        cross_wavelet(i,*) = CONVOL((cross_wavelet(i,*))(*),weights, /EDGE_TRUNCATE)
        power1(i,*) = CONVOL((power1(i,*))(*),weights, /EDGE_TRUNCATE)
        power2(i,*) = CONVOL((power2(i,*))(*),weights, /EDGE_TRUNCATE)
    endfor ;*** scale-smoothing

    wave_phase = reform(ATAN(IMAGINARY(cross_wavelet),REAL_PART(cross_wavelet)))*(180./!pi)
    wave_coher = (ABS(cross_wavelet)^2)/(power1*power2 > 1E-9)

    ; cospectrum = ABS(REAL_PART(cross_wavelet))
    cospectrum = ABS(cross_wavelet);/frequency[nf-1] ; in DN^2
    coherence=reform(wave_coher)
    phase_angle=reform(wave_phase)
    
 return, cospectrum

end
;==================================================== MAIN ROUTINE ====================================================
pro walsa_wavelet_cross_spectrum, $
    data1,data2,time, $   ;*** required inputs
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
    arrowdensity=arrowdensity,arrowsize=arrowsize,arrowheadsize=arrowheadsize,noarrow=noarrow,silent=silent
    
    ; assuming the two time series are temporally aligned
    time1 = time
    time2 = time
    
    if n_elements(plot) eq 0 then plot = 0
    if n_elements(log) eq 0 then log = 0
    if n_elements(dj) eq 0 then dj = 0.025
    if n_elements(nosignificance) eq 0 then nosignificance = 0
    if n_elements(nodetrendapod) eq 0 then nodetrendapod = 0
    if n_elements(nperm) eq 0 then nperm = 50
    if n_elements(siglevel) eq 0 then siglevel=0.05 ; 5% significance level = 95% confidence level
    if n_elements(removespace) eq 0 then removespace=0
    if n_elements(silent) eq 0 then silent=0
    
    sizecube1 = size(reform(data1))
    sizecube2 = size(reform(data2))
    
    givewarning = 0
    if sizecube1[0] eq 1 and sizecube1[0] eq 1 then begin
        if sizecube1[1] ne sizecube1[1] then givewarning = 1
        if n_elements(time) ne sizecube1[1] then givewarning = 1
        if n_elements(time) ne sizecube2[1] then givewarning = 1
    endif else givewarning = 1
    if givewarning eq 1 then begin
        print, ' '
        print, ' [!] data1, data2, and time must be one diemnsional and have identical lengths.'
        print, ' '
        stop
    endif
    
    if silent eq 0 then begin
        cadence=walsa_mode(walsa_diff(time))
        temporal_Nyquist = 1. / (cadence * 2.)
        print,' '
        print,'The input datacubes are of size: ['+ARR2STR(sizecube1[1],/trim)+']'
        print,'Temporally, the important values are:'
        print,'    2-element duration (Nyquist period) = '+ARR2STR((cadence * 2.),/trim)+' seconds'
        print,'    Time series duration = '+ARR2STR(cadence*sizecube1[1],/trim)+' seconds'
        print,'    Nyquist frequency = '+ARR2STR(temporal_Nyquist*1000.,/trim)+' mHz'
        print, ' '
    endif
    
    cospectrum = walsa_getcorss_spectrum_wavelet(data1,time1,data2,time2,mother=mother,param=param,dj=dj,colornoise=colornoise,coherence=coherence,phase_angle=phase_angle, $
                                         TIME_OUT=time_out,SCAle_OUT=scale_out,COI_OUT=coi_out,CROSS_WAVEleT=cross_wavelet,POWER1=power1,POWER2=power2, $
                                         frequency=frequency,nosignificance=nosignificance,koclt=koclt, $
                                         log=log,period=period,plot=plot,clt=clt,removespace=removespace,$
                                         coh_global=coh_global, phase_global=phase_global, cross_global=cross_global, $
                                         coh_oglobal=coh_oglobal, phase_oglobal=phase_oglobal, cross_oglobal=cross_oglobal, $
                                         padding=padding, apod=apod, nodetrendapod=nodetrendapod, pxdetrend=pxdetrend, meandetrend=meandetrend,$
                                         polyfit=polyfit,meantemporal=meantemporal)
    
    nxx = n_elements(cospectrum[*,0])
    nyy = n_elements(cospectrum[0,*])
    
    if nosignificance eq 0 then begin
        ndata1 = n_elements(data1)
        dt1 = walsa_mode(walsa_diff(time1))
        ndata2 = n_elements(data2)
        dt2 = round(walsa_mode(walsa_diff(time2)))
        
        coh_perm = fltarr(nxx,nyy,nperm)
        cross_perm = fltarr(nxx,nyy,nperm)
        for ip=0L, nperm-1 do begin
            permutation1 = walsa_randperm(ndata1)
            y_perm1 = data1(permutation1)
            permutation2 = walsa_randperm(ndata2)
            y_perm2 = data2(permutation2)
            cospectrumsig = walsa_getcorss_spectrum_wavelet(y_perm1,time1,y_perm2,time2,coherence=cohsig, $
                                                 mother=mother,param=param,dj=dj,colornoise=colornoise, $
                                                 log=0,plot=0,silent=1,padding=padding,apod=apod,nodetrendapod=nodetrendapod, $
                                                 pxdetrend=pxdetrend, meandetrend=meandetrend,polyfit=polyfit,meantemporal=meantemporal)
            
            coh_perm[*,*,ip] = cohsig
            cross_perm[*,*,ip] = cospectrumsig
            if ip eq 0 then PRINT
            print,string(13b)+' >>> % Running Monte Carlo (significance): ',(ip*100.)/(nperm-1),format='(a,f4.0,$)'
        endfor
        PRINT
        PRINT
        signif_coh = walsa_confidencelevel_wavelet(coh_perm, siglevel=siglevel)
        signif_cross = walsa_confidencelevel_wavelet(cross_perm, siglevel=siglevel)
    endif
    
    if plot eq 1 then begin
        powplot = cospectrum
        perplot = period
        timplot = time_out
        coiplot = coi_out
        walsa_plot_wavelet_cross_spectrum, powplot, perplot, timplot, coiplot, clt=clt, w=8, phase_angle=phase_angle, log=log, normal=pownormal, $
                                           /crossspectrum, arrowdensity=arrowdensity,arrowsize=arrowsize,arrowheadsize=arrowheadsize, $
                                           noarrow=noarrow, significancelevel=signif_cross, nosignificance=nosignificance,removespace=removespace
        
        powplot = coherence
        perplot = period
        timplot = time_out
        coiplot = coi_out
        walsa_plot_wavelet_cross_spectrum, powplot, perplot, timplot, coiplot, clt=clt, w=9, phase_angle=phase_angle, log=0, normal=pownormal, $
                                           /coherencespectrum, arrowdensity=arrowdensity,arrowsize=arrowsize,arrowheadsize=arrowheadsize, $
                                           noarrow=noarrow, significancelevel=signif_coh, nosignificance=nosignificance,removespace=removespace
    endif
    
    frequency = 1000./period ; in mHz
    time = time_out
    coi = coi_out
    scale = scale_out
    
print,''
print, 'COMPLETED!'
print,''

end