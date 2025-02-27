FUNCTION wave_recon, ts, delt, $
    	    dj=dj, lo_cutoff=lo_cutoff, hi_cutoff=hi_cutoff, upper=upper, display=display

    dur = (N_ELEMENTS(ts) - 1.) * delt
    
    IF NOT KEYWORD_SET(dj) THEN dj = 32. ELSE dj = dj
    IF NOT KEYWORD_SET(lo_cutoff) THEN lo_cutoff = 0. ELSE lo_cutoff = lo_cutoff
    IF NOT KEYWORD_SET(hi_cutoff) THEN hi_cutoff = dur / (3. * sqrt(2.)) ELSE hi_cutoff = hi_cutoff
    
    wave_trans = WAVELET(ts,delt,PERIOD=period,SCALE=scale,$
    	    	    	    COI=coi,/PAD,SIGNIF=signif,siglvl=0.99,$
			    FFT_THEOR=fft_theor,mother=mother,DJ= 1./dj)

    IF KEYWORD_SET(upper) THEN BEGIN
    	good_per = ( WHERE(period GT hi_cutoff) )(0)
		  bad_per = N_ELEMENTS(period)
    ENDIF ELSE BEGIN
    	good_per = ( WHERE(period GT lo_cutoff) )(0)
	    bad_per = ( WHERE(period GT hi_cutoff) )(0)
    ENDELSE
    
    recon_sum = FLTARR( N_ELEMENTS(ts) )
    FOR i = good_per, bad_per - 1. DO recon_sum += $
    	    ( REAL_PART( wave_trans(*,i) ) / SQRT( scale(i) ) )

    recon_all = dj * SQRT(delt) * recon_sum / ( 0.766 * ( !pi^(-0.25) ) )
    
    IF KEYWORD_SET(display) THEN BEGIN
    	WINDOW, 24, TITLE='(24) Original Wavelet Plot', XSIZE=640, YSIZE=710
    	sdbwave, ts, delt=delt, /fast, /cone, /ylog, /print
    	WINDOW, 26, TITLE='(26) Reconstructed Wavelet Plot', XSIZE=640, YSIZE=710
    	sdbwave, recon_all, delt=delt, /fast, /cone, /ylog, /print
    ENDIF

    RETURN, recon_all

END
