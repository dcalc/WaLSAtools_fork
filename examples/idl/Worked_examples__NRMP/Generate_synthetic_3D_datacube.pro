; pro NRMP__synthetic_wave_3D_final
; +
; for the Nature Reviews Methods Primer
; ----------------------------------------------------------------------------------------------------------------------
;     Generating synthetic time series of 2D images, by creating a circular shaped elements/regions oscilalting in time
;     More specifically, the code creates a complex wave pattern with propagating waves, 
;     which are characterised by their changing phase over time.
;	  10 wave signature
; NRMP_signal_3D_copy_4: fluting: 1.2, 0.7 (100)
; NRMP_signal_3D_copy_5: fluting: 1.5, 0.1 (100)
; NRMP_signal_3D_copy_6: fluting: 1.7, 0.1 (50)
; NRMP_signal_3D_copy_7: fluting: 1.7, 0.7 (50)  
; NRMP_signal_3D_copy_8: fluting: 1.7, 0.55 (50) ---> NRMP_signal_3D_v2
; ----------------------------------------------------------------------------------------------------------------------
cal = 1
if cal eq 1 then begin
	
	; parameters for synthetic 2D image creation
	synthetic_image =[130.,50.,100.,2.]
	; image size = synthetic_image[0]
	; number of oscillation regions (circular) = synthetic_image[1]
	; largest radius = synthetic_image[2]
	; decrement for the radius per region = synthetic_image[3]
	
    image_size = synthetic_image[0]
    num_oscillation_regions = synthetic_image[1]  ; Increased number of oscillation regions
	
    ; all oscillation regions centered at the middle of the image
    center_x = image_size / 2.
    center_y = image_size / 2.

    ; oscillation regions with different radii, spaced evenly
    ; decrementing the radius by synthetic_image[3] units for each subsequent circle
    oscillation_region_info = FLTARR(3, num_oscillation_regions)
    for region_index = 0L, num_oscillation_regions-1 do begin
        oscillation_region_info[0, region_index] = center_x
        oscillation_region_info[1, region_index] = center_y
        oscillation_region_info[2, region_index] = synthetic_image[2] - synthetic_image[3] * region_index
    endfor
	
	; wave parameters
	num_waves = 10
	intensity_amplitudes =  [1.60, 1.80, 1.90, 1.70, 1.20, 2.00, 2.40, 1.20, 1.80, 2.20]

	; base_frequency = 0.10
	; frequency_increment = 0.05
	; intensity_frequencies = base_frequency + FINDGEN(num_waves) * frequency_increment
	intensity_frequencies = [0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55]

	phase_shifts = [0, 0.5, 1.0, 1.5, 2.0, 0.25, 0.75, 1.25, 1.75, 2.25]
    
    ; time series parameters
    ; num_frames = 200.
	; duration = 99.5
	
	num_frames = 5000.
    duration = 2500.
	
    time = findgen(num_frames) / (num_frames-1.) * duration

    ; transient signal parvameters
    polynomial_coefficients = [0.01, -0.02, 0.03]  ; coefficients for a cubic polynomial

    ; create image time-series (3D cube) 
    time_series = fltarr(image_size, image_size, num_frames)
    time_series_no_noise = fltarr(image_size, image_size, num_frames)

    ; transverse oscilaltion parameters
    sway_amplitude_x = 14.0  ; Amplitude of swaying in the X direction
    sway_amplitude_y = 10.0  ; Amplitude of swaying in the Y direction
    sway_frequency_x = 0.25 ; Frequency of swaying in the X direction
    sway_frequency_y = 0.25  ; Frequency of swaying in the Y direction

    ; fluting mode parameters
    fluting_amplitude = 14.0
    fluting_frequency = 0.50
	fluting_wavenumber = 3
	
	; Quasi-periodic signal parameters
	quasi_amplitude = 5.2
	quasi_frequency = 0.55
	quasi_phase_shift = 0.5

    for k = 0L, num_frames-1 do begin
        ; calculate transient signal value for this frame
        transient_signal = poly(1.0 * k / num_frames, polynomial_coefficients)

        ; calculate swaying motion for this frame
        sway_x = sway_amplitude_x * sin(2 * !pi * sway_frequency_x * time[k])
        sway_y = sway_amplitude_y * sin(2 * !pi * sway_frequency_y * time[k])
		
		; compute quasi-periodic signal for this frame
		quasi_periodic_signal = quasi_amplitude * sin(2 * !pi * quasi_frequency * time[k] + quasi_phase_shift)

        for i = 0L, image_size-1 do begin
            for j = 0, image_size-1 do begin
                intensity = 0.0

                ; calculate distance and angle to the center of the image
                dx = i - center_x + sway_x
                dy = j - center_y + sway_y
                distance_to_center = sqrt(dx^2 + dy^2)
                angle = atan(dy, dx)
				if angle lt 0 then angle = angle + 2 * !pi

				; calculate wave shape within each region with its unique frequency
				for region_index = 0L, num_oscillation_regions-1 do begin
				    region_radius = oscillation_region_info[2, region_index]
					
					; apply fluting effect only to the selected central regions
					fluting_effect = 0.0
                    ; if region_index ge 10 then begin
					if (region_index ge num_oscillation_regions/2. - 2.) and (region_index le num_oscillation_regions/2.) then begin
                        ; fluting_effect = fluting_amplitude * sin(2 * !pi * fluting_frequency * angle)
						fluting_effect = fluting_amplitude * sin(fluting_wavenumber * angle) * sin(2 * !pi * fluting_frequency * time[k])
                    endif
					
				    ; adjust the wave frequency dynamically for the region (resulting in various dominant frequencies across the images)
				    local_frequency = intensity_frequencies[region_index mod num_waves]

				    for wave = 0L, num_waves-1 do begin
				        wave_amplitude = intensity_amplitudes[wave]
				        wave_phase_propagating = 2. * !PI * local_frequency * time[k]
				        wave_phase = wave_phase_propagating  ; assuming all waves are propagating

				        wave_shape = SIN(2. * !PI * local_frequency * distance_to_center / region_radius + phase_shifts[wave] + wave_phase)
				        intensity += wave_amplitude * wave_shape
				    endfor
					
	                ; add fluting effect to the calculated intensity
	                intensity += fluting_effect
					
				endfor
				
				; combine intensity with transient signal and quasi-periodic signal -- no noise
				time_series_no_noise[i, j, k] = intensity * (1 + transient_signal) + quasi_periodic_signal
            
				; combine intensity with transient signal, quasi-periodic signal and add noise
				time_series[i, j, k] = intensity * (1 + transient_signal) + quasi_periodic_signal + (randomu(seed) - 0.5) * 0.1
            endfor
        endfor
		print, 'Frame: '+strtrim(k,2)
    endfor

    ; print parameters of the different waves
    PRINT, 'Wave Parameters:'
    for wave = 0, num_waves-1 do begin
        PRINT, 'Wave ', wave + 1
        PRINT, 'Amplitude: ', intensity_amplitudes[wave]
        PRINT, 'Frequency: ', intensity_frequencies[wave]
        PRINT, 'Phase Shift: ', phase_shifts[wave]
        PRINT, 'Waveform: Sine'  ; All waves are sine for this setup
    endfor

    ; print transverse motion parameters
    PRINT, 'Transverse Motion Parameters:'
    PRINT, 'X Direction Amplitude: ', sway_amplitude_x
    PRINT, 'X Direction Frequency: ', sway_frequency_x
    PRINT, 'Y Direction Amplitude: ', sway_amplitude_y
    PRINT, 'Y Direction Frequency: ', sway_frequency_y

    ; print fluting mode parameters
    PRINT, 'Fluting Mode Parameters:'
    PRINT, 'Amplitude: ', fluting_amplitude
    PRINT, 'Frequency (Number of Nodes): ', fluting_frequency

    ; print transient signal parameters
    PRINT, 'Transient Polynomial Signal Coefficients: ', polynomial_coefficients

    ; save the datacuebs
    writefits, 'Synthetic_Data/NRMP_signal_3D_large.fits', time_series
    dummy = readfits('Synthetic_Data/NRMP_signal_3D_large.fits', hdr)

    SXADDPAR, hdr, 'TIME', 'SEE EXT=1 OF THE FITS FILE'

    mwrfits, time_series, 'Synthetic_Data/NRMP_signal_3D_large.fits', hdr, /create
    mwrfits, time, 'Synthetic_Data/NRMP_signal_3D_large.fits'

    ; mwrfits, time_series_no_noise, 'NRMP_signal_3D_no_noise_final.fits', hdr, /create
    ; mwrfits, time, 'NRMP_signal_3D_no_noise_final.fits'

	;++++++
	sjim, time_series, /mv, cc=.5, w=4, clt=1, fps=5
	stop
endif


time_series = readfits('Synthetic_Data/NRMP_signal_3D.fits')
	
	;++++++
	; ---- 6-consecutive-snapshots figure:
	; colset
	; device, decomposed=0
	; walsa_eps, size=[35,25]
	; !p.font=0
	; device,set_font='Times-Roman'
	; charsize = 3.5
	; !x.thick=6.
	; !y.thick=6.
	; !x.ticklen=-0.06
	; !y.ticklen=-0.06
	;
	; loadct, 1
	;
	; !P.MULTI = [0, 3, 2]
	; pos = cgLayout([3,2],OXMargin=[0,0],OYMargin=[0,0],XGAP=6.0,YGAP=-3.0)
	;
	; for i=0L, 5 do begin
	; 	im = reform(time_series[*,*,i])
	; 	walsa_image_plot, iris_histo_opt(im), xrange=xrg, yrange=yrg, nobar=1, zrange=minmax(im), /nocolor, $
	;              contour=0, exact=1, aspect=1, cutaspect=1, barpos=1, noxval=1, distbar=80, $
	; 			noyval=1, cblog=cblog, position=pos[*,i], $
	; 			  XTICKNAME=XTICKNAME, YTICKNAME=YTICKNAME, $
	; 			    ZTICKNAME=ZTICKNAME
	; 	cgPlotS, 15, 114, PSym=16, SymColor='Black', SymSize=8.5
	; 	cgPlotS, 15, 114, PSym=16, SymColor='White', SymSize=8.
	; 	cgtext, 15, 107, ALIGNMENT=0.5, CHARSIZE=charsize*1.2, /data, strtrim(long(i+1.),2), color=cgColor('Black')
	; endfor
	;
	; walsa_endeps, filename='./synthetic_3D_snapshot'
	;++++++
	
	; ---- movie:
	for i=0L, 199 do begin
		colset
		device, decomposed=0
		walsa_eps, size=[15,15]
		!p.font=0
		device,set_font='helvetica'
		charsize = 1.7
		!x.thick=6.
		!y.thick=6.
		!x.ticklen=-0.04
		!y.ticklen=-0.04

		loadct, 1
		im = reform(time_series[*,*,i])
		walsa_image_plot, iris_histo_opt(im), xrange=xrg, yrange=yrg, nobar=1, zrange=minmax(im), /nocolor, $
	             contour=0, exact=1, aspect=1, cutaspect=1, barpos=1, noxval=0, distbar=80, $
				noyval=0, cblog=cblog, charsize=charsize, $
				  XTICKNAME=XTICKNAME, YTICKNAME=YTICKNAME, $
				    ZTICKNAME=ZTICKNAME, xtitle='(pixels)', ytitle='(pixels)'
		walsa_endeps, filename='mv/im_'+strtrim(long(1000.+i),2)
	endfor

	stop
	
    ; display the time-series of images as movie
    sjim, time_series, /mv, cc=.5, w=4, fps=5
    sjim, time_series_no_noise, /mv, cc=.5, w=4, fps=5

    ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ; --- Apply WaLSAtools to compute wave parameters using different analysis methods
    ; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    ; assuming pixel size = 1 arcsec
    WaLSAtools, /komega, signal=time_series, time=time, arcsecpx=1, power=power, frequencies=frequencies, wavenumber=k, /smooth, epsfilename='k-omega', xr=[0,0.6]

    walsatools, /wavelet, signal=time_series[30,50,*], time=time, power=p, frequencies=f, significance=signif, coi=coi
    WaLSA_plot_wavelet_spectrum, p, 1000./f, time, coi, signif, /log, /remove

stop
end