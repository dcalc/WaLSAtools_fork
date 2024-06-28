function walsa_plot_vector, u, v, x, y, angle=angle, head_len=head_len,$
                 maxmag=maxmag, align=align, length=length,$
                 ref_text=ref_text, COLOR=color, THICK=thick, cstyle=cstyle, myphi=myphi, charsize=charsize

;Procedure to calculate and plot a vector
mylen=300.0 ; length of default arrow in pixels
rev=1.0    
x0=0.0
y0=0.0
x1=u/maxmag*mylen*length
y1=v/maxmag*mylen*length
dx=x1-x0
if (dx LT 0.0) then rev=-1.0
dy=y1-y0
r=SQRT(dx^2+dy^2)
theta=ATAN(dy/dx)     
phi=angle*!dtor
rfrac=head_len 
x2=x1-r*rfrac*rev*COS(theta-phi)
y2=y1-r*rfrac*rev*SIN(theta-phi)
x3=x1-r*rfrac*rev*COS(theta+phi)
y3=y1-r*rfrac*rev*SIN(theta+phi)
x4=x1-rfrac/2*r*rev*COS(theta)
y4=y1-rfrac/2*r*rev*SIN(theta)
;Calculate intersection of vector shaft and head points either
;side of the shaft - see
;http://astronomy.swin.edu.au/~pbourke/geometry/lineline2d
;for more details
ua=((x3-x2)*(y0-y2)-(y3-y2)*(x0-x2))/$
   ((y3-y2)*(x1-x0)-(x3-x2)*(y1-y0))
x5=x0+ua*(x1-x0)
y5=y0+ua*(y1-y0) 

outputval = 1
               
;Plot vectors in data space - cstyle=0
;Position in device coordinates and then convert to data coordinates
if (cstyle EQ 0) then begin
    pt1=CONVERT_COORD(x,y, /DATA, /TO_DEVICE)
    xpts=[x0,x1,x2,x3,x4,x5]+pt1[0]-align*dx
    ypts=[y0,y1,y2,y3,y4,y5]+pt1[1]-align*dy
    pts=CONVERT_COORD(xpts,ypts, /DEVICE, /TO_DATA)
    xpts=pts[0,*]
    ypts=pts[1,*]
    x0=xpts[0]
    x1=xpts[1]
    x2=xpts[2]
    x3=xpts[3]
    x4=xpts[4]
    x5=xpts[5]
    y0=ypts[0]
    y1=ypts[1]
    y2=ypts[2]
    y3=ypts[3]
    y4=ypts[4]
    y5=ypts[5]   

    ; Plot the vectors omiting any vectors with NaNs
    z=[xpts, ypts]   
    if (TOTAL(FINITE(z)) EQ 12) then begin
        PLOTS, [x0,x5,x3,x1,x2,x5], [y0,y5,y3,y1,y2,y5], COLOR=color, THICK=thick, NOCLIP=0
        POLYFILL, [x2,x1,x3],[y2,y1,y3], COLOR=color, THICK=thick, NOCLIP=0
    endif
 
endif

;Plot reference vector - cstyle=1
;Position in device coordinates and then convert to data coordinates
if (cstyle EQ 1) then begin
    pt1=CONVERT_COORD(x,y, /NORMAL, /TO_DEVICE)
    xpts=[x0,x1,x2,x3,x4,x5]+pt1[0]
    ypts=[y0,y1,y2,y3,y4,y5]+pt1[1]
    x0=xpts[0]
    x1=xpts[1]
    x2=xpts[2]
    x3=xpts[3]
    x4=xpts[4]
    x5=xpts[5]
    y0=ypts[0]
    y1=ypts[1]
    y2=ypts[2]
    y3=ypts[3]
    y4=ypts[4]
    y5=ypts[5]
       
    ; Plot the vectors omiting any vectors with NaNs
    z=[xpts, ypts]   
    if (TOTAL(FINITE(z)) EQ 12) then begin
        PLOTS, [x0,x5,x3,x1,x2,x5], [y0,y5,y3,y1,y2,y5], COLOR=color, THICK=thick, /DEVICE
        POLYFILL, [x2,x1,x3],[y2,y1,y3], COLOR=color, THICK=thick, /DEVICE
    endif
	
    ;Add the reference vector text
    xoffset = round(abs(x3-x2))/2.
    yoffset = round(abs(y3-y2))
    if myphi eq 0 then CGTEXT, x0, y0+(2.5*yoffset), cgGreek('phi')+'=0'+cgSymbol('deg'), ALIGNMENT=0.0, COLOR=color, /DEVICE, charsize=1.1
    if myphi eq 90 then CGTEXT, x0+(2.*xoffset), y0+(2.*xoffset), cgGreek('phi')+'=90'+cgSymbol('deg'), ALIGNMENT=0.0, COLOR=color, /DEVICE, charsize=1.1
endif

return, outputval

end     
;----------------------------------------------------------------------------
function walsa_vector, u,v,x,y, LENGTH = length,$
        Color=color, XSTRIDE=xstride, YSTRIDE=ystride, ALIGN=align, $
        REF_MAG=ref_mag, ANGLE=angle, HEAD_LEN=head_len,$
        REF_POS=ref_pos, REF_TEXT=ref_text, OVERPLOT=overplot, _EXTRA=extra, THICK=thick, charsize=charsize
        
a=SIZE(u)
b=SIZE(v)
c=SIZE(x)
d=SIZE(y)

;Initialise parameters if undefined
if (N_ELEMENTS(XSTRIDE) EQ 0) then xstride=0
if (N_ELEMENTS(YSTRIDE) EQ 0) then ystride=0
if N_ELEMENTS(LENGTH) EQ 0 then length=1.0
if N_ELEMENTS(COLOR) EQ 0 then color = !P.COLOR
if (N_ELEMENTS(ANGLE) EQ 0) then angle=22.5
if (N_ELEMENTS(HEAD_LEN) EQ 0) then head_len=0.3
if (N_ELEMENTS(TYPE) EQ 0) then TYPE=0
if (N_ELEMENTS(ALIGN) EQ 0) then align=0.5  
if (N_ELEMENTS(REF_TEXT) EQ 0) then ref_text=' '
if (N_ELEMENTS(REF_MAG) EQ 0) then begin
    maxmag=MAX(ABS(SQRT(u^2.+v^2.)))
endif ELSE begin
    maxmag=ref_mag
endELSE

outputval = 1

;Setup the plot area if undefined
if (NOT KEYWORD_SET(overplot)) then begin
    xs=x[0]-(x(1)-x(0))
    xf=x[N_ELEMENTS(x)-1]+(x(1)-x(0))
    ys=y[0]-(y(1)-y(0))
    yf=y[N_ELEMENTS(y)-1]+(y(1)-y(0))  
    PLOT,[xs,xf],[ys,yf], XSTYLE=1, YSTYLE=1, /NODATA,$
       COLOR=color, _EXTRA = extra
endif

;do stride data reduction if needed 
if (xstride GT 1) then begin
    mypts=FLTARR(a[1], a[2])
    mypts[*,*]=0.0     
    for iy=0,a[2]-1,xstride do begin
        for ix=0,a[1]-1,ystride do begin
            if ( ((ix/xstride) EQ FIX(ix/xstride)) AND $
               ((iy/ystride) EQ FIX(iy/ystride)) ) then mypts[ix,iy]=1.0
        endfor
    endfor
    pts=WHERE(mypts LT 1.0)
    u[pts]=0.0
    v[pts]=0.0
endif 

;Main vector plotting loop
for ix=1, N_ELEMENTS(x)-1 do begin
    for iy=1, N_ELEMENTS(y)-1 do begin
        tempt = walsa_plot_vector(u(ix,iy), v(ix,iy), x(ix), y(iy), $
               angle=angle, head_len=head_len,$
               maxmag=maxmag, align=align, length=length,$
               color=color, cstyle=0, THICK=thick)
    endfor
endfor

;Plot reference arrow(s)
if (N_ELEMENTS(REF_POS) NE 0) then begin
    tempt = walsa_plot_vector(2.*maxmag, 0.0, ref_pos[0], ref_pos[1], $
               angle=angle, ref_text=ref_text, head_len=head_len-0.2,$
               maxmag=maxmag, align=align, length=length,$
               color=color, cstyle=1, thick=thick, myphi=0, charsize=charsize)
  
    tempt = walsa_plot_vector(0.0, 2.*maxmag, ref_pos[0], ref_pos[1]+0.04, $
               angle=angle, ref_text=ref_text, head_len=head_len-0.2,$
               maxmag=maxmag, align=align, length=length,$
               color=color, cstyle=1, thick=thick, myphi=90, charsize=charsize)
endif

return, outputval

end
;----------------------------------------------------------------------------
pro walsa_plot_wavelet_cross_spectrum_panel, power, period, time, coi, significancelevel=significancelevel, clt=clt, $
                                       phase_angle=phase_angle, log=log, crossspectrum=crossspectrum, normal=normal, epsfilename=epsfilename, ztitle=ztitle, $ 
                                       coherencespectrum=coherencespectrum, noarrow=noarrow, w=w, nosignificance=nosignificance, maxperiod=maxperiod, ref_pos=ref_pos, $
                                       arrowdensity=arrowdensity,arrowsize=arrowsize,arrowheadsize=arrowheadsize,removespace=removespace, koclt=koclt, position=position

if n_elements(crossspectrum) eq 0 then crossspectrum = 0
if n_elements(coherencespectrum) eq 0 then coherencespectrum = 0
if n_elements(log) eq 0 then log = 1
arrowdensity = [15,9]
arrowsize = 1.
arrowheadsize = 1.
arrowthick = 2.
if n_elements(nosignificance) eq 0 then nosignificance = 0
if n_elements(noarrow) eq 0 then noarrow = 0
if n_elements(removespace) eq 0 then removespace=0
if n_elements(normal) eq 0 then normal=0
if n_elements(epsfilename) eq 0 then eps = 0 else eps = 1 

eps = 0 

if crossspectrum eq 0 and coherencespectrum eq 0 then begin
    PRINT
    PRINT, ' Please define which one to plot: cross spectrum or coherence'
    PRINT
    stop
endif

if crossspectrum ne 0 and coherencespectrum ne 0 then begin
    PRINT
    PRINT, ' Please define which one to plot: cross spectrum or coherence'
    PRINT
    stop
endif

nt = n_elements(reform(time))
np = n_elements(reform(period))

fundf = 1./(time[nt-1]) ; fundamental frequency (frequency resolution) in mHz
if n_elements(maxperiod) eq 0 then maxp = 1./fundf else maxp = maxperiod ; longest period to be plotted
if n_elements(maxperiod) eq 0 then if removespace ne 0 then maxp = max(coi) ; remove areas below the COI
iit = closest_index(maxp,period)

period = period[0:iit]
if nosignificance eq 0 then isig = reform(significancelevel[*,0:iit])
power = reform(power[*,0:iit])
power = reverse(power,2)

np = n_elements(reform(period))

aphaseangle = reverse(phase_angle,2)
aphaseangle = reform(aphaseangle[*,0:iit])

if nosignificance eq 0 then isig = reverse(isig,2)
if nosignificance eq 0 then sigi = power/isig

if n_elements(w) eq 0 then w=8

dimensions = GET_SCREEN_SIZE(RESOLUTION=resolution)
xscreensize = dimensions[0]
yscreensize = dimensions[1]
IF (xscreensize le yscreensize) THEN smallest_screensize = xscreensize
IF (yscreensize le xscreensize) THEN smallest_screensize = yscreensize

charsize = 1.75
!x.thick=4.
!y.thick=4.
!x.ticklen=-0.053
!y.ticklen=-0.031
barthick = 300
distbar = 300
coithick = 3.
arrowsize = 20.*arrowsize
arrowthick = (3.5/2.)*arrowthick
c_thick = 3.
h_thick = 1.4
; !y.tickinterval = 100.
; arrowheadsize = 10.

colset               
device,decomposed=0

xtitle = 'Time (s)'

if crossspectrum ne 0 then begin
    if normal ne 0 then begin
        ; ztitle = 'Normalised Cross Power!C'
;         if log ne 0 then ztitle = 'Log!d10!n(Normalised Cross Power)!C'
    endif else begin
        ; ztitle = 'Cross Power!C'
        ; if log ne 0 then ztitle = 'Log!d10!n(Cross Power)!C'
    endelse
endif
if coherencespectrum ne 0 then begin
    ; ztitle = 'Coherence!C'
    ; if log ne 0 then ztitle = 'Log!d10!n(Coherence)!C'
endif

ii = where(power lt 0., cii)
if cii gt 0 then power(ii) = 0.
if crossspectrum ne 0 then if normal ne 0 then power = 100.*power/max(power)

xrg = minmax(time)
yrg = [max(period),min(period)]

; userlct,/full,verbose=0,coltab=nnn
if n_elements(clt) eq 0 then clt=20
loadct, clt
if n_elements(koclt) ne 0 then walsa_kopowercolor, koclt

if log ne 0 then power = alog10(power)

walsa_image_plot, power, xrange=xrg, yrange=yrg, $
          nobar=0, zrange=minmax(power,/nan), /ylog, $
          contour=0, /nocolor, charsize=charsize, $
          ztitle=ztitle, xtitle=xtitle,  $
          exact=1, aspect=0, cutaspect=0, ystyle=5, $
          barpos=1, zlen=-0.6, distbar=distbar, $ 
          barthick=barthick, position=position

cgAxis, YAxis=0, YRange=yrg, ystyle=1, /ylog, charsize=charsize, ytitle='Period (s)'

; Lblv = LOGLEVELS([max(period),min(period)])
; axlabel, Lblv, charsize=charsize, color=cgColor('Black') ,format='(i12)'

cgAxis, YAxis=1, YRange=[1./yrg[0],1./yrg[1]], ystyle=1, /ylog, title='Frequency (Hz)', charsize=charsize


; plot phase angles as arrows
angle = aphaseangle
UU = cos(d2r(angle))
VV = sin(d2r(angle))

; ref_pos = [0.025,0.815]

if noarrow eq 0 then $
tempt = walsa_vector(UU, VV, time, period, /overplot, color=cgColor('Black'), length=0.04*arrowsize, ySTRIDE=round(nt/float(ArrowDensity[0])), $
     xSTRIDE=round(np/float(ArrowDensity[1])), thick=arrowthick, head_len=0.5*arrowheadsize, ref_pos=ref_pos, align=0.5, charsize=charsize)

; plot the Cone-of-Influence
plots, time, coi, noclip=0, linestyle=0, thick=coithick, color=cgColor('Black')
; shade the area above the Cone-of-Influence, with hashed lines:
ncoi = n_elements(coi)
y = fltarr(ncoi)
for j=0, ncoi-1 do y(j) = maxp
walsa_curvefill, time, y, coi, color = cgColor('Black'), thick=h_thick, /LINE_FILL, ORIENTATION=45
walsa_curvefill, time, y, coi, color = cgColor('Black'), thick=h_thick, /LINE_FILL, ORIENTATION=-45

; contours mark significance level
if nosignificance eq 0 then $
cgContour, sigi, /noerase, levels=1., XTICKforMAT="(A1)", YTICKforMAT="(A1)", $
     xthick=1.e-40, ythick=1.e-40, xticklen=1.e-40, yticklen=1.e-40, xticks=1.e-40, yticks=1.e-40, $
     c_colors=[cgColor('Navy')], label=0, $
     c_linestyle=0, c_thick=c_thick

end
