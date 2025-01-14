; pro NRMP__synthetic_wave_2D__phaseShifted
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

; Parameters for the synthetic wave components
num_waves = 5

freq = [5.0, 12.0, 15.0, 18.0, 25.0]            ; Frequencies of the five waves (in Hz)
amp = [1.0, 0.5, 0.8, 0.3, 0.6]                 ; Amplitudes of the five waves
phase = [0.0, !PI/4, !PI/2, 3*!PI/4, !PI]       ; Initial phases of the five waves (radians)

delta_phase = [0.5, -0.8, 0.7, -1.0, 1.2]       ; Phase shifts for the five waves (radians)
; Adjusted phases with shifts:
phase = [phase[0]+delta_phase[0], phase[1]+delta_phase[1], phase[2]+delta_phase[2], phase[3]+delta_phase[3], phase[4]+delta_phase[4]]

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

weak_signal_phase_shift = -0.8 ; Additional phase shift for weak signal (radians)

; Parameters for quasi-periodic signatures
quasi_periodic_freq = 10.0             ; Base frequency of the quasi-periodic signature (in Hz)
quasi_periodic_amplitude = 0.3         ; Amplitude of the quasi-periodic signature
quasi_periodic_modulation_freq = 0.5   ; Modulation frequency of the quasi-periodic signature

quasi_periodic_phase_shift = 1.0       ; Phase shift for the quasi-periodic signature (radians)

; Parameters for nonlinear transformation
nonlinear_factor = 0.1    ; Nonlinear factor for the transformation

; Parameters for noise
noise_amplitude = 0.2     ; Amplitude of the noise

; Sampling parameters
sampling_rate = 100.0     ; Sampling rate (in Hz)
duration = 10.0           ; Duration of the signal (in seconds)

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

; Add weak signal with phase shift
synthetic_signal += weak_signal_amplitude * sin(2 * !PI * weak_signal_freq * time + weak_signal_phase_shift)

; Add quasi-periodic perturbation with phase shift
quasi_periodic_signature = quasi_periodic_amplitude * sin(2 * !PI * quasi_periodic_freq * time + quasi_periodic_phase_shift) * sin(2 * !PI * quasi_periodic_modulation_freq * time)
synthetic_signal += quasi_periodic_signature

; Add noise
noise = noise_amplitude * randomn(seed, n_elements(synthetic_signal))
synthetic_signal_with_noise = synthetic_signal + noise

; Plot the results
window, 2, xs=1600, ys=600
cgplot, time, synthetic_signal_with_noise, title='Synthetic Signal', color=cgColor('Navy'), xtitle='Time (s)', ytitle = 'Amplitude'
first_signal = readfits('Synthetic_Data/NRMP_signal_1D.fits')
oplot, time, first_signal, color=cgColor('Red')


sf = long([freq,transient_freq,weak_signal_freq,quasi_periodic_freq])
sf = sf(sort(sf))

stitle = '['+strtrim(sf[0],2)+', '+strtrim(sf[1],2)+', '+strtrim(sf[2],2)+', '+strtrim(sf[3],2)+', '+ $
	strtrim(sf[4],2)+', '+strtrim(sf[5],2)+', '+strtrim(sf[6],2)+', '+strtrim(sf[7],2)+']'

writefits, 'Synthetic_Data/NRMP_signal_1D_phase_shifted.fits', reform(synthetic_signal_with_noise)
dummy = readfits('Synthetic_Data/NRMP_signal_1D_phase_shifted.fits', hdr)

SXADDPAR, hdr, 'TIME', 'SEE EXT=1 OF THE FITS FILE'

mwrfits, reform(synthetic_signal_with_noise), 'Synthetic_Data/NRMP_signal_1D_phase_shifted.fits', hdr, /create
mwrfits, time, 'Synthetic_Data/NRMP_signal_1D_phase_shifted.fits'

; ++++++++++

; colset
; device, decomposed=0
; walsa_eps, size=[25,14.5]
; !p.font=0
; device,set_font='Times-Roman'
; charsize = 3.5
; !x.thick=9.
; !y.thick=9.
;
; cgplot, time, synthetic_signal_with_noise, /xs, color=cgColor('DodgerBlue'), charsize=charsize, /NOERASE, xtitle='Time (s)', thick=7, position=[0.1,0.2,0.95,0.95], YTICKINTERVAL=3, yr=[-4,7.5], xticklen=0.055, yticklen=0.03
;
; cgtext, -1.1, -4.+(7.5+4)/2., ALIGNMENT=0.5, CHARSIZE=charsize, /data, 'Amplitude', color=cgColor('Black'), ORIENTATION=90
;
; walsa_endeps, filename='./synthetic_1D_signal'
;
stop

; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; --- Apply WaLSAtools to compute wave parameters using different analysis methods
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

walsatools_power_spectra, synthetic_signal_with_noise, time, stitle, sf, appendix1=appendix1

; WaLSAtools, /fft, signal=synthetic_signal_with_noise, time=time, power=power, frequencies=frequencies, significance=signif
;
; ; FFT
; window, 0, xs=1600, ys=600
; cgplot, frequencies/1000., power ;, yr=[0,0.0001]
; oplot, frequencies/1000., signif, color=cgColor('Red')

stop
end