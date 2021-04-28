FUNCTION linear, x, p   
  ; used by ssw's mpfitfun
  ymod=p[0] + x * p[1] 
  return, ymod
END

FUNCTION walsa_apodcube,cube,apod,meandetrend,pxdetrend
   
  ; apodizes the temporal (x,y,*) columns of an (x,y,t) data cube
  ; optional detrending, either mean image sequence or per (x,y) pixel
  ; based on a recipe from Rob Rutten

  if (n_elements(apod) ne 0) then apod=apod else apod=0.1
  if not keyword_set(meandetrend) then meandetrend=0
  if (n_elements(pxdetrend) ne 0) then pxdetrend=pxdetrend else pxdetrend=2
  
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
      meancol=walsa_avgstd(col)
      if (meandetrend) then col=col-meanfit
      if (pxdetrend eq 1) then begin
        pxfitp=poly_fit(tf,col,1) 
        col=col-pxfitp[0]-tf*pxfitp[1]+meancol  
      endif
      if (pxdetrend eq 2) then begin
         pxfitp = mpfitfun('linear',tf,col,fltarr(nt)+1,[meancol, 0.],/quiet)
         col=col-pxfitp[0]-tf*pxfitp[1]+meancol  
      endif 
      apocube[ix,iy,*]=(col-meancol)*apodt+meancol
    endfor
    if long(nx) gt 1 then if (pxdetrend ne 0) then $ 
      writeu,-1,string(format='(%"\r == detrend next row... ",i5,"/",i5)',ix+1,nx)
  endfor
  PRINT

  return, reform(apocube)
END