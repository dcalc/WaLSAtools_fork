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


;+
; NAME: WaLSA_dominant_frequency
;       part of -- WaLSAtools --
;
; PURPOSE:
;   Compute spatially averaged power spectrum (of multiple power spectra)
;
; CALLING SEQUENCE:
;   averaged_power = walsa_averaged_power_spectrum(powercube, frequency)
;
; + INPUTS:
;   powercube:      2D or 3D cube of power spectra (1D power spectrum is also accepted!)
;   frequency:      frequency 1D arraye
;
; + OUTPUTS:
;   averaged_power:   spatially averaged power spectrum in DN^2/units_of_frequency
;
;  © WaLSA | Shahin Jafarzadeh
;-

function walsa_averaged_power_spectrum, powercube, frequency

  sizecube = size(powercube)
  if sizecube[0] eq 1 then begin
      blablacube = fltarr(1,1,sizecube[1])
      blablacube[0,0,*] = powercube
      powercube = blablacube
  endif
  if sizecube[0] eq 2 then begin
      blablacube = fltarr(1,sizecube[1],sizecube[2])
      blablacube[0,*,*] = powercube
      powercube = blablacube
  endif
  
  pm = reform(powercube)
  nx = n_elements(pm[*,0,0])
  ny = n_elements(pm[0,*,0])
  nf = n_elements(pm[0,0,*])
  if frequency[0] eq 0 then begin
	  frequency=frequency[1:nf-1]
	  pm = pm[*,*,1:nf-1]
	  pm = pm/frequency[0]
  endif
  nf = n_elements(frequency)
  avgp = fltarr(nf)
  for x=0L, nx-1 do for y=0L, ny-1 do avgp = avgp + reform(pm[x,y,*])
  avgp = avgp/float(nx)/float(ny)
  
return, avgp

end