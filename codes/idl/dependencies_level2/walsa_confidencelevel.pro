function walsa_confidencelevel, ps_perm, siglevel=siglevel, nf=nf
  ; find probability of false alarm at siglevel
  signif = dblarr(nf)
  for iv=0L, nf-1 do begin
	  tmp = reform(ps_perm[iv,*])
	  tmp = tmp(sort(tmp))
	  ntmp = n_elements(tmp)
	  nsig = siglevel*ntmp
	  signif[iv] = tmp[round(ntmp-nsig)]	
  endfor
  
  return, signif
end