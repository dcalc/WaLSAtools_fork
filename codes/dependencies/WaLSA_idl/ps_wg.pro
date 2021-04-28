pro check_sys,command,result
  common psset,psset
  
  case psset.os_family of
    'UNIX': begin
      spawn,'type '+command+' 2>/dev/null',result
    end
    'WINDOWS':begin
      spawn,'bin/which.bat '+command,result
    end
    else: result=''
  endcase
  
end

pro psset_closeviewer
  common psset,psset
  
  fs=fstat(psset.viewer_unit)
  if fs.open eq 1 then if fs.unit ne 0 then free_lun,psset.viewer_unit
end

pro psset_default
  common pswg,pswg
  common psset,psset
  
  if n_elements(psset) ne 0 then store=psset.store
  psset={file:'plot.ps',size:[19.2,27.3],offset:[0.9,1.2],paper:0, $
         encaps:0,color:0,orientation:0,view:1,autosize:1,margin:[1.,1.], $
         ps2pdf:'',psviewer:'',pdfviewer:'',pdf:0,papername:'a4', $
         os_family:strupcase(!version.os_family),viewer_unit:-1l, $
         store:strarr(10),png:0,jpg:0,cancel:0}
  if n_elements(store) ne 0 then psset.store=store

                                ;check for helper programs:
  spawn,'type ps2pdf 2>/dev/null',result
  check_sys,'ps2pdf',result
  if result ne '' then begin
    str=strsplit(result,/extract)
    psset.ps2pdf=str(n_elements(str)-1)
  endif
  if psset.ps2pdf eq '' then $
    print,'ps2pdf not present in $PATH. No pdf conversion possible.'
  gv=['okular','evince','gv','ghostview','display','gsview32.exe'] 
  i=0
  repeat begin 
    check_sys,gv(i),result
    if result ne '' then begin
      str=strsplit(result,/extract)
      psset.psviewer=str(n_elements(str)-1)
    endif
    i=i+1
  endrep until i ge n_elements(gv) or psset.psviewer ne ''
  if psset.psviewer eq '' then $
    print,'No ps-file viewer found in $PATH.'
  gv=['okular','evince','acroread','gv','display','AcroRd32.exe'] 
  i=0
  repeat begin 
    check_sys,gv(i),result
    if result ne '' then begin
      str=strsplit(result,/extract)
      psset.pdfviewer=str(n_elements(str)-1)
    endif
    i=i+1
  endrep until i ge n_elements(gv) or psset.pdfviewer ne ''
  if psset.pdfviewer eq '' then $
    print,'No pdf-file viewer found in $PATH.'
end

pro szoff_up
  common pswg,pswg
  common psset,psset
  
  for i=0,1 do begin
    widget_control,pswg.size(i).id,set_value=psset.size(i)
    widget_control,pswg.offset(i).id,set_value=psset.offset(i)
  endfor
  widget_control,pswg.file.id,set_value=psset.file
  widget_control,pswg.encaps.id,set_value=psset.encaps
  widget_control,pswg.orientation.id,set_value=psset.orientation
  widget_control,pswg.color.id,set_value=psset.color
  widget_control,pswg.paper.id,set_value=psset.paper
  widget_control,pswg.view.id,set_value=psset.view
  widget_control,pswg.pdf.id,set_value=psset.pdf

end

pro ps_getsize
  common psset,psset
  
  if psset.autosize then begin
    xs=([21.*sqrt(2)^(indgen(5)),21.6])(psset.paper)
    ys=([29.7*sqrt(2)^(indgen(5)),27.94])(psset.paper)
    name=['a4','a3','a2','a1','a0','letter']
    psset.papername=name(psset.paper)
    sz=[xs-2*psset.margin(0),ys-2*psset.margin(1)]
  endif else begin
    sz=psset.size
  endelse
;  if psset.encaps eq 0 then psset.margin=[1.,1.] else psset.margin=[0.,0.]
  if psset.orientation eq 1 then if sz(1) gt sz(0) then sz=reverse(sz)
  psset.size=sz
  
  margin=psset.margin
  if psset.encaps eq 1 then margin(*)=0.
  if psset.orientation eq 0 then psset.offset=margin $
  else begin
    psset.offset=[margin(0),margin(1)+sz(0)]
  endelse
  
end

pro ps_setext
  common psset,psset
  
  extpos=strpos(psset.file,'.',/reverse_search)
  ext=strmid(psset.file,extpos,strlen(psset.file))
  if psset.encaps eq 1 and ext eq '.ps' then $
    psset.file=strmid(psset.file,0,extpos)+'.eps'
  if psset.encaps eq 0 and ext eq '.eps' then $
    psset.file=strmid(psset.file,0,extpos)+'.ps'
end

function store_abbrev
  common psset,psset
  
  nstore=max(where(psset.store ne ''))>0
  store=psset.store(0:nstore)
  
  lmax=32
  for i=0,nstore do begin
    lslpos=strpos(store(i),'/',/reverse_search)
    store(i)=strmid(store(i),lslpos+1,strlen(store(i)))
    slen=strlen(store(i))
    if slen ge lmax then begin
      store(i)=strmid(store(i),0,lmax/2-2)+'....'+ $
        strmid(store(i),slen-(lmax/2-2),slen)
    endif
  endfor
  return,store
end


pro pswg_event,event
  common pswg,pswg
  common psset,psset
  common retval,retval
  
  update=1
  widget_control,event.id,get_uvalue=uval
  case uval of
    'orientation': psset.orientation=event.value
    'color': psset.color=event.value
    'encaps': begin
      psset.encaps=event.value
      ps_setext
    end
    'view': psset.view=event.select
    'pdf': psset.pdf=event.select
    'file': begin
      psset.file=event.value
      update=0
    end
    'paper': begin
      psset.paper=event.value
      psset.autosize=1
    end
    'size0': begin
      psset.size(0)=event.value
      update=0
      psset.autosize=0
    end
    'size1': begin
      psset.size(1)=event.value
      update=0
      psset.autosize=0
    end
    'offset0': begin
      psset.offset(0)=event.value
      update=0
      psset.autosize=0
    end
    'offset1': begin
      psset.offset(1)=event.value
      update=0
      psset.autosize=0
    end
    'store': begin
      if psset.store(event.index) ne '' then begin
        psset.file=psset.store(event.index)
        widget_control,pswg.file.id,set_value=psset.file
      endif
    end
    'control': begin
      closewg=0
      case event.value of
        'cancel': begin
          psset.cancel=1
          retval(1)=1
          closewg=1
        end
        'default': psset_default
        'okay': begin
          store=remove_multi([psset.file,psset.store])
          nst=n_elements(store)
          npst=n_elements(psset.store) 
          psset.store(0:(nst-1)<(npst-1))=store(0:(nst-1)<(npst-1))
          if nst lt npst then psset.store(nst:npst-1)=''
          widget_control,pswg.store.id,set_value=store_abbrev()
                                ;check if file exists
          fi=file_info(psset.file)
          if fi.exists then begin
            yn=dialog_message(['File '''+psset.file+ $
                               ''' already exists.','Overwrite?'], $
                              /question,/default_no, $
                              dialog_parent=pswg.base.id,title=psset.file)
            if strupcase(yn) eq 'YES' then closewg=1
          endif else closewg=1
          retval(1)=0
        end
      endcase
      if closewg then begin
        widget_control,pswg.base.id,/destroy
        update=0
      endif
    end
    else: begin
      help,/st,event
    end
  endcase
  ps_getsize
  if update then szoff_up
end

pro pswg_create,group_leader=group_leader,modal=modal
  common pswg,pswg
  common psset,psset
  
  subst={id:0l,val:0.,str:''}
  if n_elements(pswg) eq 0 then begin
    pswg={base:subst,file:subst,size:replicate(subst,2), $
          offset:replicate(subst,2),color:subst,paper:subst, $
          encaps:subst,orientation:subst,view:subst,pdf:subst,store:subst, $
          control:subst}
  endif
  pswg.base.id=widget_base(title='Save Postscript File',/col, $
                           group_leader=group_leader,modal=keyword_set(modal),$
                           floating=n_elements(group_leader) ne 0)
  
  sub_base=widget_base(pswg.base.id,/row)
  lft=widget_base(sub_base,/col)
  rgt=widget_base(sub_base,/col)
  sub_base=widget_base(rgt,/row)
  pswg.paper.id=cw_bgroup(sub_base,['A4','A3','A2','A1','A0','US'], $
                          /exclusive,/col,/frame,uvalue='paper', $
                          set_value=psset.paper)
  
  sub_base=widget_base(lft,col=2,/base_align_right)
  sstr=['Size:','']
  ostr=['Offset:','']
  for i=0,1 do begin
    pswg.size(i).id=cw_field(sub_base,/float,xsize=6,/all_events, $
                             title=sstr(i), $
                             value=psset.size(i),uvalue='size'+n2s(i))
    pswg.offset(i).id=cw_field(sub_base,/float,xsize=6,/all_events, $
                               title=ostr(i), $
                               value=psset.offset(i),uvalue='offset'+n2s(i))
  endfor
  sub_base=widget_base(lft,/row)
  pswg.orientation.id=cw_bgroup(sub_base,['Portrait','Landscape'],/row, $
                                /exclusive,set_value=psset.orientation, $
                                /frame,uvalue='orientation')
  sub_base=widget_base(lft,/base_align_left,col=2)
  pswg.color.id=cw_bgroup(sub_base,['Color','B/W'],/exclusive,/col, $
                          set_value=psset.color,/frame,uvalue='color')
;  sub_base=widget_base(pswg.base.id,/row)
  pswg.encaps.id=cw_bgroup(sub_base,['Non-Encaps.','Encaps.'], $
                           /exclusive,/col, $
                           set_value=psset.encaps,/frame,uvalue='encaps')
  
  sub=widget_base(lft,/row,/frame)
  pswg.view.id=cw_bgroup(sub,['View'],/nonexclusive, $
                         set_value=psset.view,/row,uvalue='view')
  widget_control,pswg.view.id,sensitive=psset.psviewer ne ''
  pswg.pdf.id=cw_bgroup(sub,['Convert to PDF'],/nonexclusive, $
                        set_value=psset.pdf,/row,uvalue='pdf')
  widget_control,pswg.pdf.id,sensitive=psset.pdfviewer ne ''
  
  sub=widget_base(pswg.base.id,col=1,/frame)
;  sub1=widget_base(sub,row=1)
  lab=widget_label(sub,value='Filename:',/align_left)
  pswg.store.id=widget_droplist(sub,uvalue='store')
  widget_control,pswg.store.id,set_value=store_abbrev()
  pswg.file.id=cw_field(sub,title='',/string,xsize=36, $
                        /all_events,value=psset.file,uvalue='file')

  sub=widget_base(pswg.base.id,/row)
  pswg.control.id=cw_bgroup(sub,['Okay','Default','Cancel'], $
                            uvalue='control',row=1, $
                            button_uvalue=['okay','default','cancel'])
  widget_control,pswg.base.id,/realize
  xmanager,'pswg',pswg.base.id,group_leader=group_leader
  
  
end


function ps_wg,file=file,size=size,offset=offset,paper=paper,no_x=no_x, $
               encapsulated=encaps,color=color,psname=psname, $
               orientation=orientation,view=view,keep_settings=keep_settings, $
               group_leader=group_leader,_extra=_extra,init=init, $
               modal=modal
  common pswg,pswg
  common psset,psset
  common retval,retval
  
  retval=intarr(8)
  keep=0
  if n_elements(psset) eq 0 then begin
    psset_default
  endif else keep=1
  if keyword_set(init) then return,retval
  
  if n_elements(file) ne 0 then begin
    psset.file=file
  endif
  if strmid(psset.file,strlen(psset.file)-3,3) eq '.ps' then begin
    encaps=0
    psset.encaps=0
  endif
  if keyword_set(keep_settings) eq 0 or keep eq 0 then begin
    if n_elements(size) eq 2 then begin
      psset.size=size
      psset.autosize=0
    endif
    if n_elements(offset) eq 2 then psset.offset=offset
    if n_elements(paper) eq 1 then psset.paper=paper
    if n_elements(encaps) eq 1 then psset.encaps=encaps
    if n_elements(color) eq 1 then psset.color=color
    if n_elements(view) eq 1 then psset.view=view
    if n_elements(orientation) eq 1 then psset.color=orientation
  endif
  ps_setext
                                ; if n_elements(pswg) ne 0 then begin
                                ;   widget_control,pswg.base.id,iconify=0,bad_id=bad_id,BASE_SET_TITLE=str
                                ;   if bad_id eq 0 and n_elements(str) ne 0 then return,retval $
                                ;   else dummy=temporary(pswg)
                                ; endif
  
  ps_getsize
  if keyword_set(no_x) eq 0 then begin
    pswg_create,group_leader=group_leader,modal=modal
  endif
  
  retval(3)=psset.view
  psname=psset.file
  if retval(1) eq 0 then begin
    ps_getsize
    set_plot,'PS'
    device,color=psset.color eq 0,landscape=psset.orientation eq 1, $
      encapsulated=psset.encaps eq 1,bits=8,/cmyk, $
      xsize=psset.size(0),ysize=psset.size(1), $
      xoffset=psset.offset(0),yoffset=psset.offset(1),/isolatin1, $
      filename=psset.file,_extra=_extra
  endif
  
  return,retval
end
