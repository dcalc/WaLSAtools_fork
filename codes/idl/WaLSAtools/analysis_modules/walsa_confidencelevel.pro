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