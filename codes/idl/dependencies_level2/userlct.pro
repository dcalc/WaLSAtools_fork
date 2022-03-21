;+
; routine userlct.pro: loads user color table (matches with user_ic.pro)
; 0   ... background
; 1-15 ... user defined
; 16   ... no_valid data
; 17   ... data background
; max ... labels
;
; syntax: userlct[,coltab=base color table]
;-


function velfunc,center=center,reverse=rev,order=order,symm=symm
  
  mx=255 & mn=0
  if n_elements(center) eq 0 then center=127
  nlo=(center-mn)>1 & nhi=((mx-center+1)<256)>1
  
  if n_elements(order) eq 0 then order=1
  lo=((findgen(nlo))^order)/(float(nlo)-1)^(order-1)
  hi=(reverse(findgen(nhi))^order)/(float(nhi)-1)^(order-1)
  
  if keyword_set(symm) then begin
    diff=max([nlo,nhi])
    scl=256./diff
    locol=lo*scl+255-(nlo-1)*scl
    hicol=(hi*scl+255-(nhi-1)*scl)
    col=[locol,hicol]
  endif else begin
    locol=lo/(max(lo)>1)*255
    hicol=hi/(max(hi)>1)*255
    
    if max(lo) lt 1 then col=hicol $
    else if max(hi) lt 1 then col=locol $
    else col=[locol,hicol]
  endelse
  
  if keyword_set(rev) then col=255-col
  return,col
end


pro galsmooth,r,g,b,min=min,max=max,table=table,show=show,center=center, $
              symm=symm,neutral=neutral
  common verbose,verbose
  
  if n_elements(table) ne 1 then table=2

  case table of
    1: begin                    ;galsmooth.col colortable (APL)
      r=[0,0,0,0,0,0,0,0,0,0,0,1,2,4,5,6,7,8,9,10,12,12,14,14,15,16,16,16]
      r=[r,17,17,18,18,18,18,18,18,18,18,16,16,16,15,14,13,12,11,10,9,9,8]
      r=[r,7,6,6,4,3,2,2,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      r=[r,3,3,3,4,5,6,7,8,10,11,12,12,14,14,16,18,23,25,29,31,33,36,40,46]
      r=[r,46,52,56,59,62,66,72,78,86,91,94,102,111,120,126,130,135,139,142]
      r=[r,151,154,158,163,167,172,174,178,181,185,189,190,193,195,197,199]
      r=[r,203,207,211,213,215,218,219,220,220,222,222,223,225,226,227,228]
      r=[r,229,230,231,232,233,234,234,235,236,236,237,238,241,242,243,243]
      r=[r,244,245,245,247,247,248,248,248,249,249,249,250,250,250,250,249]
      r=[r,249,249,249,249,249,248,248,248,247,247,246,245,245,244,243,242]
      r=[r,241,241,240,239,238,237,237,235,235,234,233,232,231,230,229,228]
      r=[r,227,225,224,223,221,219,217,216,215,214,214,213,211,211,211,210]
      r=[r,208,208,206,205,204,204,202,200,199,197,196,194,200,205,210,215,250]
      g=[0,0,0,0,0,0,0,0,0,0,0,0,2,3,4,5,7,8,8,9,11,11,12,15,16,18,20,22]
      g=[g,24,26,28,29,33,36,39,41,44,47,49,52,55,58,60,65,70,72,76,79,83]
      g=[g,89,92,96,99,103,108,111,114,116,119,122,125,127,130,133,133,136]
      g=[g,140,142,144,147,149,151,153,156,158,159,162,163,164,165,167,168]
      g=[g,170,171,172,174,176,177,179,180,182,184,186,187,189,191,192,194]
      g=[g,197,199,201,202,203,204,206,208,208,209,211,213,214,216,217,218]
      g=[g,220,222,224,226,227,229,230,232,233,235,238,239,239,240,241,241]
      g=[g,242,242,242,242,242,241,241,239,238,237,236,234,233,231,229,228]
      g=[g,226,224,221,221,219,216,212,208,205,202,198,193,188,185,184,180]
      g=[g,179,176,173,169,167,163,159,155,153,152,150,148,147,144,143,141]
      g=[g,139,137,134,132,130,126,124,122,120,118,116,114,112,109,109,107]
      g=[g,103,98,96,94,90,87,86,82,80,78,76,74,73,71,69,67,66,64,62,61,59]
      g=[g,57,54,52,61,65,69,74,78,82,87,86,95,100,95,95,90,90,85,85,85,80]
      g=[g,80,75,75,70,70,60,60,70,70,70,75,75,80,80,85,90,95,200]
      b=[46,52,58,64,70,76,82,88,94,100,106,112,118,124,130,146,152,158,164]
      b=[b,170,176,176,182,188,194,200,205,210,215,220,225,230,235,240,245]
      b=[b,250,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
      b=[b,253,250,247,244,241,238,235,232,229,226,223,220,217,217,214,211]
      b=[b,208,205,202,199,196,193,190,187,184,181,178,175,172,169,166,163]
      b=[b,160,157,154,151,148,145,142,139,136,133,130,127,124,121,118,115]
      b=[b,112,109,106,103,100,97,94,94,91,88,85,82,79,76,73,70,67,64,61,58]
      b=[b,55,52,49,46,43,40,37,34,31,28,25,22,19,16,0,0,0,0,0,0,0,0,0,0,0,0]
      b=[b,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      b=[b,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,8,13,17]
      b=[b,21,26,30,34,39,43,47,52,56,61,65,69,74,78,82,87,86,95,100,104,108]
      b=[b,113,117,121,126,126,132,137,141,145,150,154,158,163,167,171,176]
      b=[b,180,184,189,200,210,220,230,250]
      if verbose eq 1 then message,/cont,'using Galileo color table 1'
    end
    3: begin                    ;APL wondr3 coltab
      r=[0,1,3,5,7,9,11,13,15,17,18,20,22,24,26,28,30,32]
      r=[r,34,35,37,39,41,43,45,47,49,51,52,54,56,58,60,62,64,66]
      r=[r,68,69,71,73,75,77,79,81,83,85,86,88,90,92,90,88,86,85]
      r=[r,83,81,79,77,75,73,71,69,67,65,63,61,59,57,55,53,51,49]
      r=[r,47,45,43,41,39,37,35,33,31,29,27,25,23,21,19,18,17,16]
      r=[r,17,22,24,28,30,32,34,37,42,48,53,56,59,62,66,71,77,84]
      r=[r,89,93,99,107,115,122,127,131,135,139,142,151,153,157,162,166,170]
      r=[r,173,176,179,182,186,189,190,193,195,197,198,202,206,210,212]
      r=[r,214,216,218,219,220,222,222,223,225,226,226,227,228,229,230,231]
      r=[r,232,233,234,234,235,236,236,237,238,240,241,242,243,243,244,245]
      r=[r,246,247,247,248,248,248,249,249,249,249,250,250,250,249,249,249]
      r=[r,249,248,248,248,247,247,246,246,245,245,244,243,242,241,241,240]
      r=[r,239,238,237,237,236,235,235,234,233,232,231,230,229,228,227,226]
      r=[r,224,223,222,220,218,217,216,215,214,214,213,211,211,210,209,208]
      r=[r,207,205,204,204,204,202,200,199,197,196,194,193,192,191,189,188]
      r=[r,187,196]
      g=[51,53,55,57,59,61,63,65,68,70,72,74,76,78,80,83,85]
      g=[g,87,89,91,93,95,98,100,102,104,106,108,110,112,114,116,118,120]
      g=[g,122,124,126,128,130,131,132,133,134,135,136,137,138,139,140,141,142]
      g=[g,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,160]
      g=[g,162,163,164,165,167,168,170,170,171,173,175,176,178,179,180,182,184]
      g=[g,186,187,189,191,192,193,196,198,200,201,202,203,204,206,208,209,211]
      g=[g,213,214,216,216,217,219,221,223,225,226,227,229,230,232,233,235,238]
      g=[g,239,239,239,240,241,241,242,242,242,242,241,241,240,238,237,236,236]
      g=[g,234,233,231,229,228,226,224,222,220,218,215,211,207,204,202,198,193]
      g=[g,189,185,184,181,179,177,174,171,168,166,162,158,155,153,152,150,148]
      g=[g,147,145,143,142,140,138,136,133,131,129,126,124,122,120,118,116,113]
      g=[g,110,108,105,101,97,95,93,89,87,86,82,80,78,76,74,73,72]
      g=[g,70,68,66,65,63,61,61,59,57,54,52,57,63,67,71,75,79]
      g=[g,83,86,87,95,99,103,107,111,115,119,123,128,132,136,140,144,148]
      g=[g,152,156,160,164,168,172,176,180,184,189,192,196,201,205,209,215]
      b=[255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
      b=[b,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
      b=[b,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
      b=[b,255,255,167,166,165,163,162,161,158,157,155,153,153,151,149,147]
      b=[b,146,142,139,137,134,131,127,124,122,119,116,114,111,108,106,103]
      b=[b,98,95,92,88,84,81,77,73,70,64,55,50,46,42,39,37]
      b=[b,35,34,32,30,29,27,25,23,21,19,18,16,15,13,12,10]
      b=[b,9,8,6,4,4,3,2,0,0,0,0,0,0,0,0,0]
      b=[b,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      b=[b,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      b=[b,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      b=[b,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      b=[b,0,0,0,0,0,0,0,0,0,2,6,10,14,18,22,26]
      b=[b,30,34,38,42,46,50,54,59,63,67,71,75,79,83,86,87]
      b=[b,95,99,103,107,111,115,119,123,129,134,138,142,146,150,154,158]
      b=[b,162,166,170,174,178,182,186,191,194,198,203,207,211,216]
      if verbose eq 1 then message,/cont,'using Galileo wondr3 color table'
    end
    4: begin                    ;blue-green-red table
      hlb=128
      r=bytarr(256) & g=bytarr(256) & b=bytarr(256)
      r(0:hlb-1)=0
      r(hlb:255)=findgen(256-hlb)/(255-hlb)*255
      b(0:hlb-1)=reverse(findgen(hlb)/(hlb-1)*255)
      b(hlb:255)=0
      g(0:hlb-1)=findgen(hlb)/(hlb-1)*255
      g(hlb:255)=reverse(findgen(256-hlb))/(255-hlb)*255   
    end
    5: begin                    ;blue-yellow-red table
      hlb=128
      r=bytarr(256) & g=bytarr(256) & b=bytarr(256)
      r(0:hlb-1)=findgen(256-hlb)/(255-hlb)*255
      r(hlb:255)=255
      b(0:hlb-1)=reverse(findgen(hlb)/(hlb-1)*255)
      b(hlb:255)=0
      g(0:hlb-1)=findgen(hlb)/(hlb-1)*255
      g(hlb:255)=reverse(findgen(256-hlb))/(255-hlb)*255   
      
      togray=36 & grayval1=[250,200,200] & grayval2=[000,000,100]
      r(255-togray+1:255)=congrid([r(255-togray),grayval1(0)],togray,/min,/int)
      b(255-togray+1:255)=congrid([b(255-togray),grayval1(1)],togray,/min,/int)
      g(255-togray+1:255)=congrid([g(255-togray),grayval1(2)],togray,/min,/int)
      r(0:togray-1)=congrid([grayval2(0),r(togray)],togray,/min,/int)
      g(0:togray-1)=congrid([grayval2(1),g(togray)],togray,/min,/int)
      b(0:togray-1)=congrid([grayval2(2),b(togray)],togray,/min,/int)
    end
    6: begin                    ;define own (see color.pro in idl-dir
      cst={r:0,g:0,b:0,pos:0}

      c=replicate(cst,7)

      c(0).r=  0 & c(0).g=  0 & c(0).b= 80 & c(0).pos=  0 ;dark
      c(1).r=  0 & c(1).g=  0 & c(1).b=255 & c(1).pos= 40 ;blue
      c(2).r=  0 & c(2).g=255 & c(2).b=  0 & c(2).pos= 80 ;green
      c(3).r=255 & c(3).g=255 & c(3).b=  0 & c(3).pos=127 ;yellow
      c(4).r=255 & c(4).g=  0 & c(4).b=  0 & c(4).pos=175 ;red
      c(5).r=255 & c(5).g=  0 & c(5).b=255 & c(5).pos=215 ;purple
      c(6).r=255 & c(6).g=222 & c(6).b=222 & c(6).pos=255 ;light red

      r=bytscl(interpol(c.r,c.pos,indgen(256)))
      g=bytscl(interpol(c.g,c.pos,indgen(256)))
      b=bytscl(interpol(c.b,c.pos,indgen(256)))

      if verbose eq 1 then message,/cont,'using Andis color table'
    end
    7: begin                    ;blue-red coltab (velocity)
      if n_elements(center) eq 0 then center=127
      if n_elements(symm) eq 0 then symm=0
      if n_elements(neutral) eq 0 then neutral=0
      if finite(center) eq 0 then center=0
      
      order=1
      r=velfunc(center=center,order=order,reverse=0,symm=symm)
      g=velfunc(center=center,order=order,reverse=0,symm=symm)
      b=velfunc(center=center,order=order,reverse=0,symm=symm)
      
       nc=n_elements(r)
       cntr_rg=(center>0)<(nc-1)
      
       if center lt nc then r(center>0:*)=255
       if center ge 0  then b(0:center<(nc-1))=255
      
                                 ;add black on blue side, yellow on red side
       fct=0.2
       ba_hi=(((255-cntr_rg)*fct)>1)<254
       bap_hi=fix(ba_hi)
       black=velfunc(center=ba_hi,order=order,reverse=0,symm=0)
       blk_hi=black(0:ba_hi-1)
       ba_lo=(((cntr_rg-0)*fct)>0)<254
       bap_lo=fix(ba_lo)
       if symm eq 1 then ba_lo=ba_hi
       black=velfunc(center=ba_lo,order=order,reverse=1,symm=0)
       blk_lo=(black(0:ba_lo))/256.*128.+128
      
       li=bap_lo-1-indgen(n_elements(blk_lo))
       wli=where(li ge 0)
       if wli(0) ne -1 then begin
         li=li(wli)
         b(li)=blk_lo(0:n_elements(li)-1)
       endif
       hi=256 - bap_hi + indgen(n_elements(blk_hi))
       whi=where(hi lt 256)
       if whi(0) ne -1 then begin
         hi=hi(whi)
         g(hi)=blk_hi(0:n_elements(hi)-1)
       endif
      
       if neutral then if center ge 0 and center lt 256 then begin
         ci=[(center-.2)>0,(center+.2)<255]
         r(ci(0):ci(1))=0 & g(ci(0):ci(1))=255 & b(ci(0):ci(1))=0
       endif
    end
    8: begin                    ;blue-yellow-red round table
      hlb=128 & togray=64
;     grayval1=250+[0,0,0]
      grayval1=[200,0,200]
      grayval2=grayval1
      
      
      r=bytarr(256) & g=bytarr(256) & b=bytarr(256)
      r(0:togray-1)=0
      r(togray:hlb-1)=findgen(hlb-togray)/(hlb-togray-1)*255
      r(hlb:255)=255
      b(0:togray-1)=255
      b(togray:hlb-1)=reverse(findgen(hlb-togray)/(hlb-togray-1)*255)
      b(hlb:255)=0
      g(*)=0
      g(togray:hlb-1)=findgen(hlb-togray)/(hlb-togray-1)*255
      g(hlb:255-togray)=reverse(findgen(hlb-togray))/(hlb-togray-1)*255   
      
      r(255-togray+1:255)=congrid([r(255-togray),grayval1(0)],togray,/min,/int)
      g(255-togray+1:255)=congrid([g(255-togray),grayval1(1)],togray,/min,/int)
      b(255-togray+1:255)=congrid([b(255-togray),grayval1(2)],togray,/min,/int)
      r(0:togray-1)=congrid([grayval2(0),r(togray)],togray,/min,/int)
      g(0:togray-1)=congrid([grayval2(1),g(togray)],togray,/min,/int)
      b(0:togray-1)=congrid([grayval2(2),b(togray)],togray,/min,/int)
    end
    9: begin                    ;same as coltab=0, but redish
      loadct,0,silent=verbose eq 0 & tvlct,/get,r,g,b
      g=fix(g/255.*60)
      b=fix(b/255.*40)
    end
    10: begin                    ;same as coltab=0, but yellowish
      loadct,0,silent=verbose eq 0 & tvlct,/get,r,g,b
      b=fix(b/255.*100)
;      b(*)=0
    end
    else: begin                 ;galsmooth2.col colortable (APL)
      r=[1,2,3,3,5,6,6,7,9,10,11,12,13,14,14,15,16,16,16,17,17,18,18,18,18]
      r=[r,18,17,16,16,15,14,13,12,12,10,9,9,9,8,7,6,6,5,4,3,2,1,1,0,0,0,0,0]
      r=[r,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,3,4,5,7,8,9,10]
      r=[r,10,12,13,14,16,19,22,25,27,30,32,35,38,42,45,49,54,57,60,64,68,74]
      r=[r,81,86,91,96,103,111,118,124,129,133,138,142,147,151,155,160,164]
      r=[r,167,171,175,178,181,184,187,190,192,194,196,199,202,206,208,211]
      r=[r,213,216,218,219,220,220,221,221,222,223,225,226,227,227,229,230]
      r=[r,230,232,233,233,234,235,235,236,236,238,240,241,242,243,243,244]
      r=[r,245,246,247,247,248,248,248,249,249,249,250,250,249,249,249,249]
      r=[r,249,249,248,248,248,247,247,246,245,245,244,243,243,242,240,240]
      r=[r,239,239,238,237,236,235,234,234,233,231,231,230,229,229,228,227]
      r=[r,225,223,223,221,220,218,216,215,214,213,213,212,211,211,210,209]
      r=[r,208,207,206,205,203,203,202,200,199,197,196,195,195,198,202,206]
      r=[r,211,214]
      g=[1,1,2,2,4,6,6,7,8,9,10,11,13,14,16,18,20,22,24,26,28,30,32,35,38,41]
      g=[g,43,46,48,51,54,56,59,63,67,71,75,77,80,85,90,93,97,100,104,107]
      g=[g,110,113,116,119,121,124,126,129,131,132,134,137,140,143,145,146]
      g=[g,149,151,153,155,157,159,161,162,163,165,166,167,168,169,170,172]
      g=[g,173,175,177,179,180,182,184,185,187,188,190,192,194,196,197,199]
      g=[g,201,202,203,204,206,207,208,209,210,212,214,216,217,218,220,222]
      g=[g,223,224,225,227,228,230,232,234,236,237,238,238,239,239,240,241]
      g=[g,241,241,241,241,240,238,237,236,236,234,233,232,230,228,226,224]
      g=[g,222,221,219,219,216,212,209,205,202,199,195,190,186,184,181,179]
      g=[g,177,174,172,169,165,162,159,156,153,151,149,147,146,144,142,141]
      g=[g,139,137,135,133,130,127,124,123,121,120,118,115,113,111,109,108]
      g=[g,106,104,100,97,95,91,89,86,83,81,78,76,74,73,72,70,68,67,65,63]
      g=[g,61,60,58,56,55,54,54,59,65,68,73,77,81,84,85,91,95,95,92,90,88,86]
      g=[g,84,83,82,80,78,75,72,69,65,62,63,65,68,70,71,73,75,79,82,86,91,94]
      b=[255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
      b=[b,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
      b=[b,255,255,255,255,255,255,255,254,253,249,246,244,241,239,236,232]
      b=[b,229,227,224,222,219,217,215,213,210,207,205,201,198,195,193,190]
      b=[b,187,184,182,179,176,173,169,167,164,162,159,156,152,150,147,145]
      b=[b,142,139,136,133,130,127,124,121,118,115,113,110,107,104,102,99]
      b=[b,97,94,92,90,87,85,82,79,76,73,70,68,65,62,59,56,53,50,47,44,42,39]
      b=[b,36,33,30,27,24,21,18,13,8,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      b=[b,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      b=[b,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,6,10,15,19,23,27,31]
      b=[b,35,39,43,47,51,56,60,65,68,73,77,81,84,85,91,97,102,106,109,113]
      b=[b,117,122,125,128,132,136,140,145,149,153,157,161,166,169,174,178]
      b=[b,182,188,195,204,214,223,228]
      if verbose eq 1 then message,/cont,'using Galileo color table 2'
    end
  endcase
  
  if n_elements(min) ne 1 then min=0
  if n_elements(max) ne 1 then max=!d.table_size-1
  
  r=congrid(r,max-min)
  g=congrid(g,max-min)
  b=congrid(b,max-min)
end

pro userlct,coltab=coltab,bg_white=bg_white,show=show,glltab=glltab, $
            nologo=nologo,reverse=reverse,cyclic=cyclic,center=center, $
            symm=symm,neutral=neutral,full=full,verbose=verbosein, $
            gamma=gamma,gamcenter=centergamma
  common verbose,verbose
  common color,color
  common galileo_table,glctab
  
  
  
;  if strlowcase(!d.name) eq 'win' or strlowcase(!d.name) eq 'x' then $
;    device,decomposed=0

  if n_elements(verbose) eq 0 then verbose=0
  if n_elements(verbosein) eq 1 then verbose=verbosein
  if n_elements(color) eq 0 then color=1
  if n_elements(coltab) eq 1 then if coltab ge 0 then $
    gllcoltab=[0,coltab] $
  else begin
    glltab=abs(temporary(coltab))
  endelse
    
;   if n_elements(glctab) ne 2 and  n_elements(coltab) eq 0 then begin
;     gllcoltab=3
;     glctab=gllcoltab
;   endif
  if n_elements(glltab) ne 0 then gllcoltab=glltab ;else if n_elements(glctab) ne 0 then gllcoltab=glctab else gllcoltab=coltab
  if n_elements(gllcoltab) eq 0 then gllcoltab=3
  
  pro_ext=0.
  max=!d.table_size-1
  if max-17 lt 5 then message,/traceback,'Not enough colors available'
  if n_elements(coltab) eq 0 then begin 
    if  color ne 0 then begin
      clt=33
      extend=[220,00,255]
      pro_ext=10.
    endif
  endif else clt=coltab
  if color eq 0 then clt=0
  if gllcoltab(0) eq 0 and n_elements(gllcoltab) eq 2 then begin
    clt=gllcoltab(1)
    pro_ext=0
  end
  
  loadct,clt,silent=verbose eq 0
  tvlct,red,green,blue, /get
  
  if keyword_set(full) then mincol=1 else mincol=17
  
  if (color eq 1 and gllcoltab(0) eq 0) or color eq 0 then begin
    if strlowcase(!d.name) eq 'ps' and clt eq 0 then begin
;       red=reverse(red)
;       blue=reverse(blue)
;       green=reverse(green)    
    endif
    if verbose eq 1 then $
      print,'highest color index: ',max,'/',!d.table_size
    if clt eq 0 then begin
      red=reverse(red)
      blue=reverse(blue)
      green=reverse(green)
    endif

    area=[0.,max]
    if !d.name eq 'PS' then area=[1.,max-1]
    if pro_ext gt 0 then begin
      nel=fix((area(1)-area(0))/100.*pro_ext)
      red_new=[red(area(0):area(1)), $
               findgen(nel)/nel*(extend(0)-red(area(1)))+red(area(1))]
      green_new=[green(area(0):area(1)), $
                 findgen(nel)/nel*(extend(1)-green(area(1)))+green(area(1))]
      blue_new=[blue(area(0):area(1)), $
                findgen(nel)/nel*(extend(2)-blue(area(1)))+blue(area(1))]
    endif else begin
      nel=0
      red_new=red & green_new=green & blue_new=blue
    endelse
    farr=findgen(max-mincol)/(max-(mincol+1))*(area(1)-area(0)+nel)
    red(mincol:max-1)=interpolate(red_new,farr)
    green(mincol:max-1)=interpolate(green_new,farr)
    blue(mincol:max-1)=interpolate(blue_new,farr)
  endif else begin
    galsmooth,rd,gr,bl,min=mincol,max=max,table=gllcoltab(0), $
              symm=symm         ;, center=center,neutral=neutral
    red(mincol:max-1)=rd & green(mincol:max-1)=gr & blue(mincol:max-1)=bl
  endelse
  
  if keyword_set(reverse) then begin
    red(mincol:max-1)=reverse(red(mincol:max-1))
    blue(mincol:max-1)=reverse(blue(mincol:max-1))
    green(mincol:max-1)=reverse(green(mincol:max-1))    
  endif
  
  hl=(max-mincol)/2+mincol
  if n_elements(center) ne 0 then begin
    cntr=1>(fix(center))<254
    cntr=(cntr/255.*(max-mincol))>1
    mfc=max-fix(cntr)-mincol
    red(mincol:max-1)= $
      [congrid(red(mincol:hl),cntr),congrid(red(hl+1:max-1),mfc)]
    green(mincol:max-1)= $
      [congrid(green(mincol:hl),cntr),congrid(green(hl+1:max-1),mfc)]
    blue(mincol:max-1)= $
      [congrid(blue(mincol:hl),cntr),congrid(blue(hl+1:max-1),mfc)] 
;    cntr=cntr+mincol
    if center lt 1 then begin
      red(mincol)=red(mincol+1)
      green(mincol)=green(mincol+1)
      blue(mincol)=blue(mincol+1)
    endif else if center gt 254 then begin
      red(max-1)=red(max-2)
      green(max-1)=green(max-2)
      blue(max-1)=blue(max-2)
    endif
  endif else cntr=hl
  
  if keyword_set(bg_white) then begin
    red(mincol)=255 & green(mincol)=255 & blue(mincol)=255
  endif
  if keyword_set(neutral) then begin
    red(cntr)=0 & green(cntr)=255 & blue(cntr)=0
;    red((cntr-1)>0)=0 & green((cntr-1)>0)=255 & blue((cntr-1)>0)=0
  endif
  
  if n_elements(gamma) ne 0 then begin
    idx=(((findgen(max-mincol)/(max-mincol-1)>1e-3))^gamma)* $
        (max-mincol-1)+mincol
    red[mincol:max-1]=interpolate(red,idx)
    green[mincol:max-1]=interpolate(green,idx)
    blue[mincol:max-1]=interpolate(blue,idx)
  endif
  if n_elements(centergamma) ne 0 then begin
    zero=(max-mincol)/2+mincol
    idx1=(((findgen(zero-mincol)/(zero-mincol-1)>1e-3))^centergamma)* $
         (zero-mincol-1)+mincol
    idx2=max-reverse((((findgen(max+1-zero-mincol)/ $
                        (max+1-zero-mincol-1)>1e-3))^centergamma)* $
                     (max+1-zero-mincol-1)+mincol)
    idx=float(round([idx1,idx2]))
;print,byte(idx1),round(idx2),size(idx1),size(idx2),size([idx1,idx2]),max-mincol
    red[mincol:max-1]=interpolate(red,idx)
    green[mincol:max-1]=interpolate(green,idx)
    blue[mincol:max-1]=interpolate(blue,idx)
  endif
  if keyword_set(full) eq 0 then begin
    
    red(1:8)=  [255,0  ,0  ,255,0  ,255,255,100]
    green(1:8)=[0  ,255,0  ,0  ,255,170,127,100]
    blue(1:8)= [0  ,0  ,255,255,255, 20,127,100]
    red(9:16)=red(1:8)/3*2
    green(9:16)=green(1:8)/3*2
    blue(9:16)=blue(1:8)/3*2
    red(9)=0 & green(9)=0 & blue(9)=0 ;black foreground color
    
    if keyword_set(nologo) eq 0 then begin

      red(7)=238 & green(7)=230 & blue(7)=205    ;brown1 for apl-logo
      red(8)=205 & green(8)=188 & blue(8)=164    ;brown2 for apl-logo
      red(10)=113 & green(10)=119 & blue(10)=24  ;brown1 for gem-logo
      red(11)=177 & green(11)=152 & blue(11)=138 ;brown2 for gem-logo
      red(12)=255 & green(12)=255 & blue(12)=0   ;yellow for mpae-logo
      red(13)=0   & green(13)=189 & blue(13)=0   ;green for mpae-logo

      red(14)=255 & green(14)=255 & blue(14)=200 ;bright yellow for mark regions
    endif

                                ;setting color for no valid data
    if color eq 1 then begin
      red(16)=200 & green(16)=200 & blue(16)=200
    endif else begin
      red(16)=250 & green(16)=250 & blue(16)=250
    endelse
    if keyword_set(bg_white) then begin
      red(16)=255 & green(16)=255 & blue(16)=255
    endif
    if gllcoltab(0) eq 3 then begin
      red(16)=250 & green(16)=250 & blue(16)=250    
    endif
    red(15)=255 & green(15)=255 & blue(15)=255

    !p.background=15
    !p.color=9
  endif else begin
    !p.background=255
    !p.color=0
    if !d.name eq 'PS' then begin
    !p.background=0
    !p.color=255
    endif
  endelse
  
  if color eq 0 then begin      ; convert all colors to bw colors
    bwcol=sqrt(red^2.+green^2.+blue^2.)/sqrt(3.)
    red=bwcol & green=bwcol & blue=bwcol
  endif
  
  if keyword_set(cyclic) then begin ;revert to color 17 for colors 210-255
    topcol=230
    nhi=max-topcol
    nlo=topcol-17
    rnew=[congrid(red(17:max-1),nlo), $
          (float(red(17))-red(max-1))/(nhi+1)*(findgen(nhi+1)+.5)+red(max-1)]
    red=[red(0:16),rnew]
    
    gnew=[congrid(green(17:max-1),nlo), $
          (float(green(17))-green(max-1))/(nhi+1)*(findgen(nhi+1)+.5)+green(max-1)]
    green=[green(0:16),gnew]
    bnew=[congrid(blue(17:max-1),nlo), $
          (float(blue(17))-blue(max-1))/(nhi+1)*(findgen(nhi+1)+.5)+blue(max-1)]
    blue=[blue(0:16),bnew]
  endif
  
  
  if strupcase(!d.name) eq 'PS' then begin
    red(max)=0 & green(max)=0 & blue(max)=0
    red(0)=255 & green(0)=255 & blue(0)=255
  endif else begin
    red(0)=0 & green(0)=0 & blue(0)=0
    red(max)=255 & green(max)=255 & blue(max)=255
  endelse

  tvlct,red,green,blue
  if keyword_set(show) then showct
end

