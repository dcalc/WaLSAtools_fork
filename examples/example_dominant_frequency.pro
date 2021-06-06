; pro example_dominant_frequency

eps = 1 ; if set, plots are outputted as an eps file, otherwise are shown in a window

data_dir = 'sample_data/'

data = readfits(data_dir+'sdo_aia1700.fits', /silent)
cadence = 12. ; sec
arcsecpx = 0.6 ; arcsec

; limit the field to a region of interest
clip = [330,400,290,360]

data = data[clip[0]:clip[1],clip[2]:clip[3],*]

nx = n_elements(data[*,0,0])
ny = n_elements(data[0,*,0])
nt = n_elements(data[0,0,*])
time = findgen(nt)*cadence
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
colset
device, decomposed=0

; x and y ranges of the image in arcsec
xrg = [0,nx-1]*arcsecpx
yrg = [0,ny-1]*arcsecpx

; define range of frequency (in mHz), for plotting. 
df = 1000./(time[nt-1]) ; fundamental frequency (frequency resolution) in mHz
xr = [df,10]
rangefreq=[0.4,10]
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; calculate mean power sepctrum and dominant-frequency map: FFT analysis
WaLSAtools, /fft, signal=data, time=time, averagedpower=averagedpower, frequencies=frequencies, dominantfreq=dominantfreq, $
            /nosignificance, power=power, rangefreq=rangefreq

;----------------------- plotting
if not eps then begin
    window, 4, xs=1000, ys=500, title='WaLSAtools: FFT analysis'
    charsize = 1.5
    barthick = 18
    distbar = 18
    !x.thick=1.5
    !y.thick=1.5
    line_thick = 2.
endif else begin
    walsa_eps, size=[24,12]
    !p.font=0
    device,set_font='Times-Roman'
    charsize = 0.9
    barthick = 500
    distbar = 500
    !x.thick=2.0
    !y.thick=2.0
    line_thick = 4.
endelse
!P.Multi = [0, 2, 1]
pos = cgLayout([2,1], OXMargin=[10,4], OYMargin=[7,5], XGap=13, YGap=11)

cgplot, frequencies, 100*averagedpower/max(averagedpower), ys=1, XTICKINTERVAL=1, xr=xr, xminor=4, charsize=charsize, xticklen=-0.03, yticklen=-0.03, position=pos[*,0], $
        xtitle='Frequency (mHz)', ytitle='Normalised Power', thick=line_thick, Color=cgColor('Red');, /ylog

ppos = pos[*,0]
xyouts, ppos[0]+((ppos[2]-ppos[0])/2.), ppos[3]+((1-ppos[3])/2.), ALIGNMENT=0.5, CHARSIZE=charsize, /normal, 'Mean Power Spectrum (FFT)', color=cgColor('Black')

walsa_kopowercolor, 1
walsa_image_plot, dominantfreq, xrange=xrg, yrange=yrg, nobar=0, zrange=minmax(dominantfreq,/nan), $
          contour=0, /nocolor, ztitle='Dominant Frequency (mHz)!C', xtitle='(arcsec)', ytitle='(arcsec)', $
          exact=1, aspect=0, cutaspect=0, barpos=1, zlen=-0.45, distbar=barthick, xticklen=-0.03, yticklen=-0.03, $
          barthick=barthick, charsize=charsize, position=pos[*,1], resample=5

if eps then walsa_endeps, filename='~/example_dominant_frequency_FFT', /noboundingbox

;-----------------------------------------------------------------------------
; calculate mean power sepctrum and dominant-frequency map: Wavelet analysis - Sensible Wavelet
WaLSAtools, /wavelet, /sensible, signal=data, time=time, averagedpower=averagedpower, frequencies=frequencies, dominantfreq=dominantfreq, $
            /nosignificance, power=power, rangefreq=rangefreq

;----------------------- plotting
if not eps then begin
    window, 5, xs=1000, ys=500, title='WaLSAtools: Wavelet analysis - Sensible Wavelet'
    charsize = 1.5
    barthick = 18
    distbar = 18
    !x.thick=1.5
    !y.thick=1.5
    line_thick = 2.
endif else begin
    walsa_eps, size=[24,12]
    !p.font=0
    device,set_font='Times-Roman'
    charsize = 0.9
    barthick = 500
    distbar = 500
    !x.thick=2.0
    !y.thick=2.0
    line_thick = 4.
endelse
!P.Multi = [0, 2, 1]
pos = cgLayout([2,1], OXMargin=[10,4], OYMargin=[7,5], XGap=13, YGap=11)

cgplot, frequencies, 100*averagedpower/max(averagedpower), ys=1, XTICKINTERVAL=1, xr=xr, xminor=4, charsize=charsize, xticklen=-0.03, yticklen=-0.03, position=pos[*,0], $
        xtitle='Frequency (mHz)', ytitle='Normalised Power', thick=line_thick, Color=cgColor('Red');, /ylog

ppos = pos[*,0]
xyouts, ppos[0]+((ppos[2]-ppos[0])/2.), ppos[3]+((1-ppos[3])/2.), ALIGNMENT=0.5, CHARSIZE=charsize, /normal, 'Mean Power Spectrum (Sensible Wavelet)', color=cgColor('Black')

walsa_kopowercolor, 1
walsa_image_plot, dominantfreq, xrange=xrg, yrange=yrg, nobar=0, zrange=minmax(dominantfreq,/nan), $
          contour=0, /nocolor, ztitle='Dominant Frequency (mHz)!C', xtitle='(arcsec)', ytitle='(arcsec)', $
          exact=1, aspect=0, cutaspect=0, barpos=1, zlen=-0.45, distbar=barthick, xticklen=-0.03, yticklen=-0.03, $
          barthick=barthick, charsize=charsize, position=pos[*,1], resample=5

if eps then walsa_endeps, filename='~/example_dominant_frequency_sensible_wavelet', /noboundingbox

;-----------------------------------------------------------------------------
!P.Multi = 0
Cleanplot, /Silent

PRINT

end