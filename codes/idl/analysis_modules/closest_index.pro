;function to compare two arrays, return array containing indices of
;closest values from array one in array2
function closest_index,arr1,arr2,diff=diff,previous=previous,next=next
  
  retarr=long(arr1*0)
  diff=arr1*0
  sort1=sort(arr1)
  sort2=sort(arr2)
  sa1=arr1(sort1)
  sa2=arr2(sort2)
  na2=n_elements(sa2)
  
  i2=-1l
  for i1=0l,n_elements(sa1)-1 do begin
    repeat i2=(i2+1)<(na2-1) until sa2(i2) ge sa1(i1) or i2 ge na2-1
    idx=([i2,(i2-1)>0])(0)
    dst=(sa2([(i2-1)>0,i2]) - sa1(i1))
    if keyword_set(previous) or keyword_set(next) then begin
      if keyword_set(previous) then snv=where(dst lt 0)
      if keyword_set(next)     then snv=where(dst gt 0)
      if snv(0) ne -1 then dst(snv)=!values.f_nan
    endif
    dummy=min(abs(dst))
    isrt1=sort1(i1)
    diff(isrt1)=sa1(i1) - sa2((!c+(i2-1))>0)
    retarr(isrt1)=sort2((!c+(i2-1))>0)
    i2=i2-1
  endfor
  
  return,retarr
end
