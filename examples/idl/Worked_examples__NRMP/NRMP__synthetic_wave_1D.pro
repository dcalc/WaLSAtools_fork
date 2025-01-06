; pro NRMP__synthetic_wave_2D
; +
; for the Nature Reviews Methods Primer
; ----------------------------------------------------------------------------------------------------------
;     Generating a synthetic signal (time-series of 1D signal) by (initially) combining five sinusoidal waves, 
;     each with specified frequencies, amplitudes, and phases
;     + introducing a time-varying amplitude for the combined signal to make it more dynamic!
;       (by modulating the amplitudes of individual waves with an envelope function)
;     + introducing nonlinearity by applying nonlinear transformation to the waveform
;     + adding a transient oscillation, a weak signal, and a quasi-periodic perturbation
;     + adding noise
; ----------------------------------------------------------------------------------------------------------

appendix1= 1 ; multiply noise amplitude and non-linear factor by 4

; Parameters for the synthetic wave components
num_waves = 5

freq = [5.0, 12.0, 15.0, 18.0, 25.0]            ; Frequencies of the five waves (in Hz)
amp = [1.0, 0.5, 0.8, 0.3, 0.6]                 ; Amplitudes of the five waves
phase = [0.0, !PI/4, !PI/2, 3*!PI/4, !PI]       ; Initial phases of the five waves (radians)

; Parameters for the amplitude envelope
envelope_freq = 0.2       ; Frequency of the amplitude envelope modulation (in Hz)
envelope_amplitude = 0.5  ; Amplitude of the amplitude envelope modulation

; Parameters for transient oscillations
transient_freq = 2.0       ; Frequency of the transient oscillations (in Hz)
transient_amplitude = 0.6  ; Amplitude of the transient oscillations
transient_duration = 2.0   ; Duration of the transient oscillations (in seconds)
transient_start_time = 3.0 ; Start time of the transient oscillations (in seconds)

; Parameters for weak signals
weak_signal_freq = 33.0     ; Frequency of the weak signal (in Hz)
weak_signal_amplitude = 0.1 ; Amplitude of the weak signal

; Parameters for quasi-periodic signatures
quasi_periodic_freq = 10.0             ; Base frequency of the quasi-periodic signature (in Hz)
quasi_periodic_amplitude = 0.3         ; Amplitude of the quasi-periodic signature
quasi_periodic_modulation_freq = 0.5  ; Modulation frequency of the quasi-periodic signature (in Hz)

; Parameters for nonlinear transformation
nonlinear_factor = 0.1    ; Nonlinear factor for the transformation ; original test
if appendix1 eq 1 then nonlinear_factor = 0.2    ; Nonlinear factor for the transformation ; additional test -- appendix

; Parameters for noise
noise_amplitude = 0.2   ; Amplitude of the noise ; original test
if appendix1 eq 1 then noise_amplitude = 0.4   ; Amplitude of the noise ; additional test -- appendix

; Sampling parameters
sampling_rate = 100.0   ; Sampling rate (in Hz)
duration = 10.0         ; Duration of the signal (in seconds)

; Generate time vector
time = findgen(duration * sampling_rate) / sampling_rate

; Generate synthetic wave components
synthetic_signal = fltarr(n_elements(time))
for i = 0, num_waves - 1 do begin
    amp_modulation = envelope_amplitude * sin(2 * !PI * envelope_freq * time)
    synthetic_signal += (amp[i] + amp_modulation) * sin(2 * !PI * freq[i] * time + phase[i])
endfor

; Apply nonlinear transformation
synthetic_signal = synthetic_signal + nonlinear_factor * synthetic_signal^2

; Add transient oscillation
transient_indices = where(time ge transient_start_time and time le (transient_start_time + transient_duration), count)
synthetic_signal[transient_indices] += transient_amplitude * sin(2 * !PI * transient_freq * time[transient_indices])

; Add weak signal
synthetic_signal += weak_signal_amplitude * sin(2 * !PI * weak_signal_freq * time)

; Add quasi-periodic perturbation
quasi_periodic_signature = quasi_periodic_amplitude * sin(2 * !PI * quasi_periodic_freq * time) * sin(2 * !PI * quasi_periodic_modulation_freq * time)
synthetic_signal += quasi_periodic_signature

; Add noise
noise = noise_amplitude * randomn(seed, n_elements(synthetic_signal))
synthetic_signal_with_noise = synthetic_signal + noise

; Plot the results
; window, 2, xs=1600, ys=600
; cgplot, time, synthetic_signal_with_noise, title='Synthetic Signal', color=cgColor('Navy'), xtitle='Time (s)', ytitle = 'Amplitude'

sf = long([freq,transient_freq,weak_signal_freq,quasi_periodic_freq])
sf = sf(sort(sf))

stitle = '['+strtrim(sf[0],2)+', '+strtrim(sf[1],2)+', '+strtrim(sf[2],2)+', '+strtrim(sf[3],2)+', '+ $
	strtrim(sf[4],2)+', '+strtrim(sf[5],2)+', '+strtrim(sf[6],2)+', '+strtrim(sf[7],2)+']'

if appendix1 eq 1 then begin
	
	writefits, 'Synthetic_Data/NRMP_signal_1D_large_noise.fits', reform(synthetic_signal)
	dummy = readfits('Synthetic_Data/NRMP_signal_1D_large_noise.fits', hdr)

	SXADDPAR, hdr, 'TIME', 'SEE EXT=1 OF THE FITS FILE'

	mwrfits, reform(synthetic_signal), 'Synthetic_Data/NRMP_signal_1D_large_noise.fits', hdr, /create
	mwrfits, time, 'Synthetic_Data/NRMP_signal_1D_large_noise.fits'
	
endif else begin

	writefits, 'Synthetic_Data/NRMP_signal_1D.fits', reform(synthetic_signal)
	dummy = readfits('Synthetic_Data/NRMP_signal_1D.fits', hdr)

	SXADDPAR, hdr, 'TIME', 'SEE EXT=1 OF THE FITS FILE'

	mwrfits, reform(synthetic_signal), 'Synthetic_Data/NRMP_signal_1D.fits', hdr, /create
	mwrfits, time, 'Synthetic_Data/NRMP_signal_1D.fits'

endelse

; ++++++++++

; colset
; device, decomposed=0
; walsa_eps, size=[25,22]
; !p.font=0
; device,set_font='Times-Roman'
; charsize = 4.2
; !x.thick=9.
; !y.thick=9.
;
; cgplot, time, synthetic_signal_with_noise*10., /xs, color=cgColor('DodgerBlue'), charsize=charsize, /NOERASE, xtitle='Time (s)', thick=7, position=[0.1,0.2,0.95,0.95], YTICKINTERVAL=40, yr=[-35,79], xticklen=0.05, yticklen=0.045
;
; cgtext, -1.3, 22., ALIGNMENT=0.5, CHARSIZE=charsize, /data, 'Amplitude', color=cgColor('Black'), ORIENTATION=90
;
; walsa_endeps, filename='Figures/synthetic_1D_signal'
;
; stop

; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; --- Apply WaLSAtools to compute wave parameters using different analysis methods
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; walsatools_power_spectra, synthetic_signal_with_noise, time, stitle, sf, appendix1=appendix1

; WaLSAtools, /fft, signal=synthetic_signal_with_noise, time=time, power=power, frequencies=frequencies, significance=signif
;
; ; FFT
; window, 0, xs=1600, ys=600
; cgplot, frequencies/1000., power ;, yr=[0,0.0001]
; oplot, frequencies/1000., signif, color=cgColor('Red')

done
stop
end