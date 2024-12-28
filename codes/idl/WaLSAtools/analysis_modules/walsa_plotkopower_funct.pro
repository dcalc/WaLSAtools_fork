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


; NAME: plotkopower --> walsa_plotkopower_funct
;
; PURPOSE: plot "k-omega" diagram = Fourier power at temporal frequency
;   f against horizontal spatial wavenumber k_h
;
; CALLING SEQUENCE:
;   plotkopower, cube, arcsecpx, cadence, plotfilename, $
;     apod=apod, $
;     kmax=kmax, fmax=fmax, minpower=minpower, maxpower=maxpower, $
;     contours=contours, lamb=lamb, fundamental=fundamental

;
; INPUTS:
;   cube: (x,y,t) data cube, any type
;   arcsecpx = angular image scale in arcsec/px
;   cadence: [regular] sampling cadence in sec
;   plotfilename: postscript output file name
;     optional keywords: 
;   apod: fractional extent of apodization edges; default 0.1
;   kmax: maximum k_h axis as fraction of Nyquist value, default 0.2
;   fmax: maximum f axis as fraction of Nyquist value, default 0.5
;   minpower: minimum of power plot range, default maxpower-5
;   maxpower: maximum of power plot range, default alog10(max(power))
;   contours: set true to plot contours
;   lamb: value > 0 overplots Lamb line omeha = c_s kn at c_s = lamb km/s 
;   fundamental: set true to overplot fundamental mode omega=sqrt(g k_h)
;
; MODIFICATION HISTORY: 
;  Sep 2010: Rob Rutten (RR) assembly of Alfred de Wijn's routines.
;  Okt 2010: RR optional overplots Lamb line and fundamental mode
;  SJ modified: based on latest version of this code (Mar 2 2012): Mar 2011: RR -1 > +1 line 162 from Alfred de Wijn
;-

;-----------------------------------------------------------------------
function avgstd, array, stdev=stdev
    ; get array average + standard deviation
    ;RR Aug 23 2010 found in Mabula Haverkamp's IDL, later also AdW
    ;RR not the same as avg.pro in ssw
    ;RR not the same as avg.pro in Pit Suetterlin DOT software
    ;RR so renamed to avgstd
  avrg = total(array,/nan)/n_elements(array)
  stdev = sqrt(total((array-avrg)^2,/nan)/n_elements(array))
  return, avrg
end

;----------------------------------------------------------------------------
function linear, x, p            ;RR used in temporal detrending 
    ymod = p[0] + x * p[1]
    return, ymod
end

;----------------------------------------------------------------------------
function gradient, x, y, p       ;RR used in spatail detrending
    zmod = p[0] + x * p[1] + y * p[2]
    return, zmod
end

;----------------------------------------------------------------------------
function apod3dcube,cube,apod
    ; apodizes cube in all three coordinates, with detrending 

  ; get cube dimensions
  sizecube=size(cube)
  nx=sizecube[1]
  ny=sizecube[2]
  nt=sizecube[3]
  apocube = fltarr(nx,ny,nt)

  ; define temporal apodization
  apodt = fltarr(nt)+1
  if (apod ne 0) then begin
    apodrimt = nt*apod
    apodt[0] = (sin(!pi/2.*findgen(apodrimt)/apodrimt))^2
    apodt = apodt*shift(rotate(apodt,2),1)   ;RR had ik nooit verzonnen
  endif 

  ; temporal detrending, not per px, only mean-image trend 
  ttrend = fltarr(nt)
  tf = findgen(nt) + 1
  for it=0, nt-1 do begin
    img = cube[*,*,it]
    ttrend[it] = avgstd(img)
  endfor
  fitp = mpfitfun('linear', tf, ttrend, fltarr(nt)+1, [1000.,0.],/quiet)
  fit = fitp[0] + tf * fitp[1]

  ; temporal apodization per (x,y) column
  ;RR do not reinsert trend to keep [0,0] Fourier pixel from dominating
  for it=0, nt-1 do begin
    img = cube[*,*,it]
    apocube[*,*,it] = (img-fit[it])*apodt[it]  ;RR  + ttrend[it]
  endfor

  ; define spatial apodization
  apodx = fltarr(nx)+1
  apody = fltarr(ny)+1
  if (apod ne 0) then begin
    apodrimx=apod*nx
    apodrimy=apod*ny
    apodx[0] = (sin(!pi/2.*findgen(apodrimx)/apodrimx))^2
    apody[0] = (sin(!pi/2.*findgen(apodrimy)/apodrimy))^2
    apodx = apodx*shift(rotate(apodx,2),1)
    apody = apody*shift(rotate(apody,2),1)
    apodxy = apodx # apody
 endif
 
 if (apod eq 0) then begin
    apodxy = apodx # apody
 endif

  ; spatial gradient removal + apodizing per image
  xf = fltarr(nx,ny)+1.
  yf = xf
  for it=0, nt-1 do begin
    img = apocube[*,*,it]
    avg = avgstd(img)
    ;RR mpfit2dfun = ssw/gen/idl/fitting/mpfit/mpfit2dfun.pro
    fitp = mpfit2dfun('gradient',xf,yf,img,fltarr(nx,ny)+1,[1000.,0.,0.],/quiet)
    fit = fitp[0]+xf*fitp[1]+yf*fitp[2]
    apocube[*,*,it] = (img-fit)*apodxy + avg
  endfor

  ; done
  return,apocube
end

;---------------------------------------------------------------------------
function ko_dist, sx, sy, double=double
    ; set up Pythagoras distance array from origin 
    ;RR from Alfred de Wijn email Aug 30 2010 
  dx = rebin(dindgen(sx/2+1)/(sx/2),sx/2+1,sy/2+1)
  dy = rotate(rebin(dindgen(sy/2+1)/(sy/2),sy/2+1,sx/2+1),1)
  dxy = sqrt(dx^2+dy^2)*(min([sx,sy],/nan)/2+1.)
  afstanden = dblarr(sx,sy)
  afstanden[0,0] = dxy
  ; get other quadrants
  afstanden[sx/2,0] = rotate(dxy[1:*,*],5)       ;RR 5 = 90 deg
  afstanden[0,sy/2] = rotate(dxy[*,1:*],7)       ;RR 7 = 270 deg
  afstanden[sx/2,sy/2] = rotate(dxy[1:*,1:*],2)  ;RR 2 = 180 deg
  if not keyword_set(double) then afstanden = fix(round(afstanden))
  return, afstanden
end

;---------------------------------------------------------------------------
function averpower,cube
  ; compute 2D (k_h,f) power array by circular averaging over k_x, k_y

  ; get cube dimensions
  sizecube=size(cube)
  nx=sizecube[1]
  ny=sizecube[2]
  nt=sizecube[3]

  ; forward fft and throw away half of it
  ; perform fft in time direction first
  fftcube = (fft(fft((fft(cube,-1, dimension=3))[*,*,0:nt/2],-1,dimension=1),dimension=2))

  ; set up distances 
  fftfmt = size(fftcube)
  afstanden = ko_dist(nx,ny)   ;RR integer-rounded Pythagoras array
  ; maxdist = min([nx,ny])/2-1   ;RR largest quarter circle
  maxdist = min([nx,ny],/nan)/2+1   ;RR largest quarter circle --> from RR on Mar 2011!

  ; get average power over all k_h distances, building power(k_h,f)
  avpow = fltarr(maxdist+1,nt/2+1)
  for i=0, maxdist do begin
    waar = where(afstanden eq i)
    for j=0, nt/2 do begin
      w1 = (fftcube[*,*,j])[waar]
      avpow[i,j] = total(w1*conj(w1),/nan)/n_elements(waar)
    endfor
;;  writeu,-1,string(format='(%"\rcomputing avpow... ",i6,"/",i6)',i,maxdist)
  endfor

  ; done
  return, avpow
end

;---------------------------------------------------------------------------
pro koplotpow,avpow,arcsecpx,cadence,kmax,fmax,minpower,maxpower
    ; plotting program
  sizepow = size(avpow)

  ; select extent = fractions of Nyquist values
  plotrange = [fix(sizepow[1]*kmax),fix(sizepow[2]*fmax)]
  plotpow = avpow[0:plotrange[0]-1,0:plotrange[1]-1]

  ;RR 5x5 resizing, I guess for better tick positioning and contours
  xas = 2.*!pi/(arcsecpx*2)*findgen(plotrange[0])/(sizepow[1]-1)
  rexas = 2.*!pi/(arcsecpx*2)*findgen(plotrange[0]*5)/(sizepow[1]*5-1)
  yas = 1./(cadence*2)*findgen(plotrange[1])/(sizepow[2]-1)*1e3
  reyas = 1./(cadence*2)*findgen(plotrange[1]*5)/(sizepow[2]*5-1)*1e3
  plotpowrebin = convol(rebin(plotpow,plotrange[0]*5,plotrange[1]*5),fltarr(6,6)+1/(6.*6.),/edge_truncate)
;  plotpowrebin=plotpow
  xrange = [min(xas,/nan),max(xas,/nan)]
  yrange = [min(yas,/nan),max(yas,/nan)]
        

tvframe,alog10(plotpowrebin) > minpower < maxpower,/ba,/sa,/as,xrange=xrange,yrange=yrange,xtitle='k_h [arcsec!U-1!N]',ytitle='f [mHz]'



  ; plot wavelength axis along top
  if (xrange[1] lt 10) then begin ;RR I wonder how to automate this  
    wavtickspos = [10, 5, 3, 2, 1.5, 1]
    wavticksn = ['10','5','3','2','1.5','1']
  endif else if (xrange[1] lt 20) then begin
    wavtickspos = [10, 5, 3, 2, 1.5, 1, 0.5]
    wavticksn = ['10','5','3','2','1.5','1','0.5']
  endif else if (xrange[1] lt 50) then begin
    wavtickspos = [5.0, 2.0, 1.0, 0.5, 0.2]
    wavticksn = ['5','2','1','0.5','0.2']
  endif else begin
    wavtickspos = [5.0, 2.0, 1.0, 0.5, 0.2, 0.1, 0.05]
    wavticksn = ['5','2','1','0.5','0.2','0.1','0.05']
  endelse
  wavticks=n_elements(wavtickspos)-1
  wavticksv = 2.*!pi/wavtickspos   ;RR wavelength from circle frequency

  axis, /xaxis, xticks=wavticks, xtickv=wavticksv, xtickname=wavticksn,ticklen=-0.015/0.53, xminor=1, xtitle='wavelength [arcsec]'

  ; plot period axis along righthand side 
  if (yrange[1] lt 10) then begin ;RR I wonder how to automate this 
    pertickspos = [20, 10, 5, 3, 2, 1]
    perticksn = ['20','10','5','3','2','1']
  endif else if (yrange[1] lt 20) then begin
    pertickspos = [10, 5, 3, 2, 1.5, 1, 0.5]
    perticksn = ['10', '5','3','2','1.5','1','0.5']
  endif else if (yrange[1] lt 50) then begin
    pertickspos = [10, 5, 2, 1, 0.5, 0.2, 0.1]
    perticksn = ['10','5','2','1','0.5','0.2','0.1']
  endif else if (yrange[1] lt 100) then begin
    pertickspos = [2, 1, 0.5, 0.2, 0.1]
    perticksn = ['2','1','0.5','0.2','0.1']
  endif else begin
    pertickspos = [0.5, 0.2, 0.1, 0.05, 0.02]
    perticksn = ['0.5','0.2','0.1','0.05','0.02']
  endelse
  perticks=n_elements(pertickspos)-1
  perticksv = 1e3/pertickspos/60.  ;RR period, from mHz to min
  axis, /yaxis, yticks=perticks, ytickv=perticksv, ytickname=perticksn,ticklen=-0.015/0.7, yminor=1, ytitle='period [min]'



end

; --------------------------- main part ------------------------------

FUNCTION walsa_plotkopower_funct,cube,sp_out,arcsecpx,cadence,apod=apod,kmax=kmax,fmax=fmax,minpower=minpower,maxpower=maxpower
    ; wrapper calling the above subroutines

if (n_elements(apod) ne 0) then apod=apod else apod=0.1
if (n_elements(kmax) ne 0) then kmax=kmax else kmax=1.0
if (n_elements(fmax) ne 0) then fmax=fmax else fmax=1.0

if (kmax gt 1) then kmax=1
if (fmax gt 1) then fmax=1



; apodize the cube
apocube=apod3dcube(cube,apod)

; compute radially-averaged power
avpow=averpower(apocube)

sp_out=avpow


; set min, max cutoffs
maxavpow=alog10(max(avpow,/nan))
minavpow=alog10(min(avpow,/nan))
print, ' max log(power) = ', maxavpow, ' min log(power) = ',minavpow
if (n_elements(maxpower) ne 0) then maxpower=maxpower else maxpower=maxavpow
if (n_elements(minpower) ne 0) then minpower=minpower else minpower=maxpower-5

;print,kmax,fmax

; plot the diagram
;koplotpow,avpow,arcsecpx,cadence,kmax,fmax,minpower,maxpower

; done

RETURN,sp_out


end








