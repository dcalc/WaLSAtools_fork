; pro FIG2__synthetic_data_figure

; Load synthetic data
data_dir= 'Synthetic_Data/'
signal_1d = readfits(data_dir+'NRMP_signal_1D.fits')
signal_3d = readfits(data_dir+'NRMP_signal_3D.fits')
time = readfits(data_dir+'NRMP_signal_1D.fits', ext=1)
	
;;++++++
;; ---- 6-consecutive-snapshots figure:
	
colset
device, decomposed=0
walsa_eps, size=[35,15]
!p.font=0
device,set_font='helvetica'
charsize = 1.7
!x.thick=6.
!y.thick=6.
!x.ticklen=-0.06
!y.ticklen=-0.06

loadct, 1

!P.MULTI = [0, 6, 2]
pos = cgLayout([6,2],OXMargin=[2,2],OYMargin=[2,2],XGAP=4.4,YGAP=-9.0)

for i=0L, 5 do begin
	if i lt 3 then j=i+3 else j=i+6
	print, pos[*,j]
	im = reform(signal_3d[*,*,i])
	if i eq 3 then noxval=0 else noxval=1
	if i eq 3 then xtitle='(pixels)' else xtitle=' '
	walsa_image_plot, iris_histo_opt(im), xrange=xrg, yrange=yrg, nobar=1, zrange=minmax(im), /nocolor, $
             contour=0, exact=1, aspect=1, cutaspect=1, barpos=1, noxval=noxval, distbar=80, $
			noyval=1, cblog=cblog, position=pos[*,j], $
			  XTICKNAME=['0',' ','40',' ','80',' ','120'], YTICKNAME=YTICKNAME, CHARSIZE=charsize*1.8, $
			    ZTICKNAME=ZTICKNAME, xtitle=xtitle
	cgPlotS, 15, 114, PSym=16, SymColor='Black', SymSize=4.5
	cgPlotS, 15, 114, PSym=16, SymColor='White', SymSize=4.
	cgtext, 15, 107, ALIGNMENT=0.5, CHARSIZE=charsize*1.1, /data, strtrim(long(i+1.),2), color=cgColor('Black')
endfor

cgplot, time, signal_1d*10., /xs, color=cgColor('DodgerBlue'), charsize=1.9*charsize, /NOERASE, xtitle='Time (s)', thick=7, position=[0.05,0.105,0.40, 0.815], YTICKINTERVAL=40, yr=[-35,79], xticklen=-0.03, yticklen=-0.027

cgtext, -1.3, 22., ALIGNMENT=0.5, CHARSIZE=charsize, /data, 'Amplitude', color=cgColor('Black'), ORIENTATION=90

walsa_endeps, filename='Figures/Fig2_synthetic_data'

stop
end