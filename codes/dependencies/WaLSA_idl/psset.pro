pro psset,ps=ps,close=close,size=sz,eps=eps,file=file,_extra=_extra, $
          landscape=landscape,encapsulated=encapsulated,cancel=cancel, $
          nowin=nowin,win_nr=win_nr, $
          gv=gv,printfile=printfile,pdf=pdf,view=view, $
          png=png,jpg=jpg,retname=psname,oldsettings=oldsettings
  common setps,psn,psout,oldsz
  common psset,psset
  
  if keyword_set(close) eq 0 then close=0
  if n_elements(psset) eq 0 then dummy=ps_wg(/init)
  if keyword_set(oldsettings) eq 0 then begin
    if n_elements(pdf) ne 0 then psset.pdf=keyword_set(pdf)
;  psset.pdf=keyword_set(pdf)
    if n_elements(gv) ne 0 then psset.view=gv
    if n_elements(encapsulated) ne 0 then psset.encaps=keyword_set(encapsulated)
    if n_elements(landscape) ne 0 then psset.orientation=landscape
    if n_elements(view) eq 1 then psset.view=view
    if n_elements(png) eq 1 then psset.png=keyword_set(png)
    if n_elements(jpg) eq 1 then psset.jpg=keyword_set(jpg)
    if n_elements(sz) eq 2 then begin
      psset.size=sz
      psset.autosize=0
    endif
  endif
  if n_elements(file) ne 0 then psset.file=file
  
  cancel=0
  if close eq 0 then begin
    if n_elements(file) eq 0 then $
      if psset.encaps then file='plot.eps' else file='plot.ps'
    if keyword_set(ps) then begin
      ; psout=ps_widget(default=[keyword_set(landscape),0, $
      ;                          keyword_set(encapsulated),0,8,0,0], $
      ;                 size=sz,psname=psn,file=file,_extra=_extra)
      psout=ps_wg(_extra=_extra,/keep_settings)
      psn=psset.file
      cancel=psout(1)
      if psout(1) eq 1 then return
      !p.font=0
;      device,set_font='Helvetica'
;      device,set_font='Helvetica',/tt_font
      device,set_font='Times-Roman'
;      device,set_font='Times-Roman',/tt_font
    endif else begin
      if keyword_set(nowin) eq 0 then begin
        szx=640
        szx=((get_screen_size())[0]*0.5)>640
        if n_elements(sz) eq 0 then sz=[szx,szx*sqrt(2)]
        xs=szx & ys=szx/sz(0)*sz(1)      
        if n_elements(win_nr) eq 0 then win_nr=0
        window,win_nr,xsize=xs,ysize=ys
      endif
    endelse
  endif else if !d.name eq 'PS' then begin ;close
    if strmid(psset.file,strlen(psset.file)-3,3) eq 'eps' then encapsulated=1
    if n_elements(printfile) eq 0 then $
      printfile=(keyword_set(encapsulated) eq 0)
    if printfile eq 1 then xyouts,0,0,/normal,'!C!C'+psset.file
    
    device,/close
    print,'Created PS-file: '+psset.file
    pdffile=''
    if psset.pdf eq 1 and psset.ps2pdf ne '' then begin
      if strmid(psset.file,strlen(psset.file)-4,4) eq '.eps' then $
        psroot=strmid(psset.file,0,strlen(psset.file)-4) $
      else if strmid(psset.file,strlen(psset.file)-3,3) eq '.ps' then $
        psroot=strmid(psset.file,0,strlen(psset.file)-3) $
      else psroot=psset.file
      pdffile=psroot+'.pdf'
      psize=' -sPAPERSIZE='+psset.papername
      ps2pdfopt=' -dMaxSubsetPct=100 -dCompatibilityLevel=1.3 -dSubsetFonts=true -dEmbedAllFonts=true -dAutoFilterColorImages=false -dAutoFilterGrayImages=false -dColorImageFilter=/FlateEncode -dGrayImageFilter=/FlateEncode -dMonoImageFilter=/FlateEncode -dPDFSETTINGS=/prepress '
      spawn,psset.ps2pdf+psize+ps2pdfopt+psset.file+ $
            ' '+pdffile,result,/stderr
;      print,' and PDF-file: '+pdffile,format='(a,$)'
      if max(strpos(strlowcase(result),'error')) eq -1 and  $
        max(strpos(strlowcase(result),'not found')) eq -1 and $
        max(strpos(strlowcase(result),'not recognized')) eq -1 then begin
        get_lun,unit & openw,unit,/delete,psset.file & free_lun,unit
        print,'Created PDF-File: '+pdffile
        psset.file=pdffile
      endif
    endif
    if psset.png then begin
      spawn,'~/bin/eps2png '+psset.file
    endif
    if psset.jpg then begin
      spawn,'~/bin/eps2jpg '+psset.file
    endif
    
    if psout(3) eq 1 or psset.view eq 1 then begin
      if pdffile eq '' then viewer=psset.psviewer $
      else viewer=psset.pdfviewer
      viewcmd=viewer+' '+psset.file
                                ;check if viewcommand is already running
      isopen=0
      if  psset.os_family eq 'UNIX' then begin
        spawn,'ps -jAf | grep '+psset.file+' | grep '+viewer+'' + $
          ' | grep -v grep',result
        if max(strlen(result)) ne 0 then begin
          print,'PS Viewer already open: '+viewcmd
          isopen=1
        endif
      endif
      if isopen eq 0 then begin
                                ;check if unit is free to spawn command
        fu=replicate({open:0,name:'',ctime:0l,unit:0l},29)
        for i=100,128 do begin
          f=fstat(i)
          fu(i-100).open=f.open
          fu(i-100).ctime=f.ctime
          fu(i-100).name=f.name
          fu(i-100).unit=f.unit
      endfor
      if total(fu.open eq 0) lt 10 then begin ;less than 10 units free.
                                ; Close one spawn-unit! 
        iview=where((strpos(fu.name,psset.psviewer) ne -1 or  $
                     strpos(fu.name,psset.pdfviewer) ne -1) and fu.open eq 1)
        if iview(0) ne -1 then begin
          fu=fu(iview)
          fu=fu(sort(fu.ctime))
          print,'Too many Viewers open, closing '+fu(0).name
          free_lun,fu(0).unit
        endif
      endif
      case psset.os_family of
        'UNIX': spawn,viewcmd+' &',unit=unit
        'WINDOWS': spawn,viewcmd,unit=unit
        else: print,'Unknown OS-Type'
      endcase
      psset.viewer_unit=unit ;viewer can be closed from IDL using the command
                                ;psset_closeviewer
      endif
    endif
    !p.font=-1 & set_plotx
    
  endif
  psname=psset.file
end
