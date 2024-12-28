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


; Wavelet filtering that chucks away periods found inside the cone-of-influence of the corresponding wavelet transform.
; This code does nothing to preserve the amplitudes, so it becomes more difficult to construct PSDs with the outputs of this code. 
; However, it is useful when attempting to examine frequencies that are far away from the 'untrustworthy' low frequencies.

FUNCTION walsa_wave_recon, ts, delt, dj=dj, lo_cutoff=lo_cutoff, hi_cutoff=hi_cutoff, upper=upper

    dur = (N_ELEMENTS(ts) - 1.) * delt
    
    IF NOT KEYWORD_SET(dj) THEN dj = 32. ELSE dj = dj
    IF NOT KEYWORD_SET(lo_cutoff) THEN lo_cutoff = 0. ELSE lo_cutoff = lo_cutoff
    IF NOT KEYWORD_SET(hi_cutoff) THEN hi_cutoff = dur / (3. * sqrt(2.)) ELSE hi_cutoff = hi_cutoff
	
	; do wavelet transform
    wave_trans = walsa_wavelet(ts,delt,PERIOD=period,SCALE=scale,$
                            COI=coi,/PAD,SIGNIF=signif,siglvl=0.99,$
                            FFT_THEOR=fft_theor,mother=mother,DJ= 1./dj)

	; set upper (and if necessary, lower) threshold on period. 
	; if not provided, an default upper threshold is set: length_of_time_series / (3. * sqrt(2.))
    IF KEYWORD_SET(upper) THEN BEGIN
        good_per = ( WHERE(period GT hi_cutoff) )(0)
        bad_per = N_ELEMENTS(period)
    ENDIF ELSE BEGIN
        good_per = ( WHERE(period GT lo_cutoff) )(0)
        bad_per = ( WHERE(period GT hi_cutoff) )(0)
    ENDELSE
	
	print
	print, '----- Filtering out frequencies below '+strtrim(1000./hi_cutoff,2)+' mHz'
	print
    
	; set the power inside the CoI equal to zero 
	; (i.e., exclude points inside the CoI -- subject to edge effect)
	iampl = fltarr(N_ELEMENTS(ts),N_ELEMENTS(period))
	for i=0L, N_ELEMENTS(ts)-1 do begin
	    pcol = reform(REAL_PART( wave_trans[i,*] ))
	    ii = where(reform(period) lt coi[i], pnum)
	    if pnum gt 0 then iampl[i,ii] = pcol[ii]
	endfor
	
	; reconstruct the signal from the wavelet amplitudes 
	; (see the last lines in the original wavelet procedure -- here, walsa_wavelet.pro)
    recon_sum = FLTARR( N_ELEMENTS(ts) )
    FOR i = good_per, bad_per - 1. DO recon_sum += $
            ( iampl[*,i] / SQRT( scale[i] ) )
	
    recon_all = dj * SQRT(delt) * recon_sum / ( 0.766 * ( !pi^(-0.25) ) )

    RETURN, recon_all

END