;+
; NAME: WaLSA_detrend_apod
;       part of -- WaLSAtools --
;
; PURPOSE:
;   Detrend and apodise time series to account for their nonlinear and nonstationary nature
;   (apodisation is also known as 'windowing' in some other communities)
;
; DESCRIPTION:
;   Each 1D time series is detrended by subtracting the signal from its fitted linear or higher 
;   polynomial degrees function (or only from the mean signal), and finally apodised by the 
;   Tukey (tapered cosine) window to bring the edges to zero. If set, the edge effects are 
;   more conservatively examined by means of a wavelet-based approach (walsa_wave_recon.pro)
;
; CALLING SEQUENCE:
;   corrected_cube = walsa_detrend_apod(cube,apod,meandetrend,pxdetrend)
;
; + INPUTS:
;   data:           1D time series, or (x,y,t) datacube, any type
;                   (an ordered sequence of data points, typically some variable quantity 
;                   measured at successive times.)
;   apod:           extent of apodization edges of the Tukey (tapered cosine) window
;                   default: 0.1
;   pxdetrend:      subtract linear trend with time per pixel. options: 1=simple, 2=advanced
;                   default: 2
;
; + OPTIONAL KEYWORDS:
;   polyfit:        	the degree of polynomial fit to the data to detrend it.
;                   	if set, instead of linear fit this polynomial fit is performed.
;   meantemporal:  		if set, only a very simple temporal detrending is performed by subtracting 
;                   	the mean signal from the signal.
;                   	i.e., the fitting procedure (linear or higher polynomial degrees) is omitted.
;   meandetrend:    	if set, subtract linear trend with time for the image means 
;                   	(i.e., spatial detrending)
;   recon:          	optional keyword that will Fourier reconstruct the input timeseries.
;                   	note: this does not preserve the amplitudes and is only useful when attempting 
;                   	to examine frequencies that are far away from the 'untrustworthy' low frequencies.
;   cadence:        	cadence of the observations. it is required when recon is set.
;	resample_original	if recon is set, then this keyword allow setting a range (i.e., min_resample and max_resample)
;						to which the unpreserved amplitudes are approximated.
;	min_resample		minimum value for resample_original. Default: min of each 1D array (time series) in data.
;	max_resample		maximum value for resample_original. Default: max of each 1D array (time series) in data.
; 
; + OUTPUTS:
;   corrected_cube:     The detrended and apodised cube
;
; MODIFICATION HISTORY
;
;  2010 plotpowermap: Rob Rutten, assembly of Alfred de Wijn's routines 
;                     (https://webspace.science.uu.nl/~rutte101/rridl/cubelib/plotpowermap.pro)
;  2018-2021 modified/extended by Shahin Jafarzadeh & David B. Jess
;-

FUNCTION linear, x, p   
  ; used by mpfitfun
  ymod=p[0] + x * p[1] 
  return, ymod
END

FUNCTION walsa_detrend_apod,cube,apod,meandetrend,pxdetrend,polyfit=polyfit,meantemporal=meantemporal,$
                            recon=recon,cadence=cadence,resample_original=resample_original,min_resample=min_resample,$
							max_resample=max_resample,silent=silent

  if (n_elements(apod) ne 0) then apod=apod else apod=0.1
  if (n_elements(polyfit) eq 0) then apolyfit=0 else apolyfit=1
  if not keyword_set(meandetrend) then meandetrend=0
  if not keyword_set(silent) then silent=0
  if (n_elements(pxdetrend) ne 0) then pxdetrend=pxdetrend else pxdetrend=2
  
  if silent eq 0 then begin
      print, ' '
      print, ' -- Detrend and apodize the cube .....'
	  print, ' '
  endif
  
  sizecube = size(cube)
  if sizecube[0] ne 3 then begin
      if sizecube[0] eq 1 then begin
          blablacube = fltarr(1,1,sizecube[1])
          blablacube[0,0,*] = cube
          cube = blablacube
      endif else begin
          print, ' '
          print, ' [!] The datacube must have either 1 or 3 dimension(s).'
          print, ' '
          stop
      endelse
  endif

  sizecube=size(cube)
  nx=sizecube[1]
  ny=sizecube[2]
  nt=sizecube[3]
  apocube=cube
  tf=findgen(nt) + 1
  col=fltarr(nt)
  apodt = fltarr(nt)+1
  if (apod ne 0) then begin ; Tukey window
      apodrim = apod*nt
      apodt[0] = (sin(!pi/2.*findgen(apodrim)/apodrim))^2
      apodt = apodt*shift(rotate(apodt,2),1)
  endif 

  ; meandetrend: get spatially-averaged trend 
  fit=0  
  if (meandetrend) then begin
      avgseq=fltarr(nt)
      for it=0,nt-1 do avgseq[it]=total(cube[*,*,it])
      avgseq=avgseq/(double(nx)*double(ny)) 
      meanfitp = mpfitfun('linear',tf,avgseq,fltarr(nt)+1,[1000.,0.],/quiet)
      meanfit=meanfitp[0]+tf*meanfitp[1]-total(avgseq)/double(nt)
  endif 
  
  ; apodize per [x,y] temporal column = time sequence per pixel
  for ix=long(0),long(nx)-1 do begin  
      for iy=long(0),long(ny)-1 do begin
          col=cube[ix,iy,*]
		  IF KEYWORD_SET(recon) THEN col = walsa_wave_recon(reform(col),cadence)
          meancol=walsa_avgstd(col)
          if (meandetrend) then col=col-meanfit
          if n_elements(meantemporal) eq 0 then begin 
              if apolyfit eq 0 then begin
                  if (pxdetrend eq 1) then begin
                      pxfitp=poly_fit(tf,col,1) 
                      col=col-pxfitp[0]-tf*pxfitp[1]+meancol  
                  endif
                  if (pxdetrend eq 2) then begin
                      pxfitp = mpfitfun('linear',tf,col,fltarr(nt)+1,[meancol, 0.],/quiet)
                      col=col-pxfitp[0]-tf*pxfitp[1]+meancol  
                  endif
              endif else begin
                  lc_fit = GOODPOLY(FINDGEN(nt), col, polyfit, 3, lc_yfit, lc_newx, lc_newy)
                  col=col-lc_yfit
              endelse
          endif
          ocol=(col-meancol)*apodt+meancol
		  if not KEYWORD_SET(min_resample) then min_resample = min(cube[ix,iy,*])
		  if not KEYWORD_SET(max_resample) then max_resample = max(cube[ix,iy,*])
		  IF KEYWORD_SET(recon) THEN if KEYWORD_SET(resample_original) then ocol = scale_vector(ocol,min_resample,max_resample)
          apocube[ix,iy,*] = ocol
      endfor
      if silent eq 0 then if long(nx) gt 1 then if (pxdetrend ne 0) then $ 
         writeu,-1,string(format='(%"\r == detrend next row... ",i5,"/",i5)',ix+1,nx)
  endfor
  if silent eq 0 then if long(nx) gt 1 then if (pxdetrend ne 0) then PRINT

  return, reform(apocube)
END