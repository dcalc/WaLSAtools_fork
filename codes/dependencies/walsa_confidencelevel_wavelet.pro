function walsa_confidencelevel_wavelet, ps_perm, siglevel=siglevel
  ; find probability of false alarm at siglevel
  sizearray = size(ps_perm)
  signif = dblarr(sizearray[1],sizearray[2])
  for ix=0L, sizearray[1]-1 do begin
	  for iy=0L, sizearray[2]-1 do begin
		  tmp = reform(ps_perm[ix,iy,*])
	  	  tmp = tmp(sort(tmp))
	  	  ntmp = n_elements(tmp)
	  	  nsig = siglevel*ntmp
	  	  signif[ix,iy] = tmp[round(ntmp-nsig)]
	  endfor	
  endfor
  
  return, signif
end