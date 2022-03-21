; pro example_cross_correlation

eps = 1 ; if set, plots are outputted as an eps file, otherwise are shown in a window

data_dir = 'sample_data/'

datacube = readfits(data_dir+'sdo_aia1700.fits', /silent)
cadence = 12. ; sec
nt = n_elements(datacube[0,0,*])
time = findgen(nt)*cadence

; signals at two random pixels in the sunspot's umbra
data1 = reform(datacube[233,231,*])
data2 = reform(datacube[231,238,*])

; cross-correlations: FFT analysis
WaLSAtools, /fft, data1=data1, data2=data2, time=time, nperm=100, cospectrum=cospectrum, phase_angle=phase_angle, $
            coherence=coherence, frequencies=frequencies, /nosignificance, d1_power=power1, d2_power=power2, n_segments=2

;----------------------- plotting
colset
device, decomposed=0

if not eps then begin
    window, 0, xs=1500, ys=600, title='WaLSAtools: cross-correlations'
    charsize = 3.0
    !x.thick=1.6
    !y.thick=1.6
    thick = 1.0
endif else begin
    walsa_eps, size=[30,12]
    !p.font=0
    device,set_font='Times-Roman'
    charsize = 2.0
    !x.thick=2.0
    !y.thick=2.0
    thick = 2.0
endelse

!P.Multi = [0, 3, 2]

!x.ticklen=-0.052
!y.ticklen=-0.025

df = frequencies[1]-frequencies[0] ; frequency resolution / the lowest detectable frequency
xr = [df,15]
tr = [min(time),max(time)]

pos = cgLayout([3,2], OXMargin=[10,4], OYMargin=[7,5], XGap=12, YGap=10)
; --------------------------------
; Plot the detrended & apodized light curve 1
signal1 = walsa_detrend_apod(data1)
cgplot, time, signal1, charsize=charsize, pos=pos[*,0], thick=thick, $
    xtitle='Time (s)', ytitle='Intensity (arb. unit)', xs=1, ys=1, color=cgColor('DodgerBlue')

xyouts, tr[0]+((tr[1]-tr[0])/2.), max(signal1)+3, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, 'Time series 1', color=cgColor('Black')
; --------------------------------
; Plot the detrended & apodized light curve 2
signal2 = walsa_detrend_apod(data2)
cgplot, time, signal2, charsize=charsize, pos=pos[*,1], thick=thick, $
    xtitle='Time (s)', ytitle='Intensity (arb. unit)', xs=1, ys=1, color=cgColor('Red')

xyouts, tr[0]+((tr[1]-tr[0])/2.), max(signal2)+2.5, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, 'Time series 2', color=cgColor('Black')
; --------------------------------
; Plot FFT power spectra of the two time series
cgplot, frequencies, power1/max(power1), charsize=charsize, pos=pos[*,2], thick=thick, $
    xtitle='Frequency (mHz)', ytitle='Normalised Power', xs=1, ys=1, xr=xr, yr=[0,1.1], color=cgColor('DodgerBlue')
oplot, frequencies, power2/max(power2), color=cgColor('Red'), thick=thick

xyouts, xr[0]+((xr[1]-xr[0])/2.), 1.2, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, 'Power spectra', color=cgColor('Black')
; --------------------------------
; Plot co-spectrum
cgplot, frequencies, cospectrum/max(cospectrum), yr=[0,1.1], xr=xr, charsize=charsize, pos=pos[*,3], thick=thick, $
    xtitle='Frequency (mHz)', ytitle='Normalised Power', color=cgColor('DarkGreen')

xyouts, xr[0]+((xr[1]-xr[0])/2.), 1.2, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, 'Co-spectrum', color=cgColor('Black')
; --------------------------------
; Plot coherence levels as a function of frequency
cgplot, frequencies, coherence, yr=[0,1.1], xr=xr, charsize=charsize, pos=pos[*,4], thick=thick, $
    xtitle='Frequency (mHz)', ytitle='Coherence', color=cgColor('DarkGreen')

xyouts, xr[0]+((xr[1]-xr[0])/2.), 1.2, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, 'Coherence level', color=cgColor('Black')
; --------------------------------
; Plot phase lags as a function of frequency
cgplot, frequencies, phase_angle, yr=[-200,200], xr=xr, charsize=charsize, pos=pos[*,5], thick=thick, $
    xtitle='Frequency (mHz)', ytitle='Phase (degrees)', color=cgColor('DarkGreen')

xyouts, xr[0]+((xr[1]-xr[0])/2.), 240, ALIGNMENT=0.5, CHARSIZE=charsize/2., /data, 'Phase Lag', color=cgColor('Black')

if eps then walsa_endeps, filename='~/example_cross-correlations_FFT', /noboundingbox

; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; Wavelet power spectrum: time series 1
WaLSAtools, /wavelet, signal=data1, time=time, power=power, period=period, significance=significance, coi=coi

walsa_plot_wavelet_spectrum, power, period, time, coi, significance, /log, /removespace, epsfilename='~/example_wavelet_data1'
;-----------------------
; Wavelet power spectrum: time series 2
WaLSAtools, /wavelet, signal=data2, time=time, power=power, period=period, significance=significance, coi=coi

WaLSA_plot_wavelet_spectrum, power, period, time, coi, significance, /log, /removespace, epsfilename='~/example_wavelet_data2'
;-----------------------
; cross-correlations: Wavelet analysis: co-spectrum
WaLSAtools, /wavelet, data1=data1, data2=data2, time=time, nperm=1000, signif_cross=signif_cross, $
            cospectrum=cospectrum, phase_angle=phase_angle, period=period, coi=coi

walsa_plot_wavelet_cross_spectrum, cospectrum, period, time, coi, clt=clt, phase_angle=phase_angle, /log, $
                                   /crossspectrum, arrowdensity=arrowdensity,arrowsize=arrowsize,arrowheadsize=arrowheadsize, $
                                   noarrow=noarrow, /removespace, significancelevel=signif_cross, epsfilename='~/example_wavelet_cospectrum'
;-----------------------
; cross-correlations: Wavelet analysis: coherency spectrum
WaLSAtools, /wavelet, data1=data1, data2=data2, time=time, nperm=1000, signif_coh=signif_coh, $
            phase_angle=phase_angle, coherence=coherence, period=period, coi=coi

walsa_plot_wavelet_cross_spectrum, coherence, period, time, coi, clt=clt, phase_angle=phase_angle, $
                                   /coherencespectrum, arrowdensity=arrowdensity,arrowsize=arrowsize,arrowheadsize=arrowheadsize, $
                                   noarrow=noarrow, /removespace, log=0, significancelevel=signif_coh, epsfilename='~/example_wavelet_coherence'
;-----------------------


PRINT
PRINT, ' DONE :-)'
PRINT
end