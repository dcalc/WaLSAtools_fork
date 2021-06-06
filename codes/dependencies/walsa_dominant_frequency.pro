;+
; NAME: WaLSA_dominant_frequency
;       part of -- WaLSAtools --
;
; PURPOSE:
;   Identify dominant frequency in a power spectrum, i.e., the frequency corresponding to the maximum power.
;            Note: if there are multiple peaks with the exact same power, the lowest dominant frequency is 
;            returned! In this case, and also if there are multiple high-power peaks the dominant frequency 
;            may not be representative of the oscillations, thus, such analysis should be performed with great caution!
;
; CALLING SEQUENCE:
;   dominantfreq = (power, frequency, frequencyrange, dominantpower=dominantpower)
;
; + INPUTS:
;   power:          1D power spectrum
;   frequency:      frequency arraye (1D; same size as the power)
;   frequencyrange: frequency range over which the dominant frequency is computed. default: full frequency range
;
; + OPTIONAL KEYWORDS:
;   dominantpower:  power of the dominant frequency
;
; + OUTPUTS:
;   dominantfreq:   the dominant frequency
;
;  © WaLSA | Shahin Jafarzadeh
;-

function walsa_dominant_frequency, power, frequency, frequencyrange, dominantpower=dominantpower

  nf = n_elements(frequency)
  if n_elements(frequencyrange) eq 0 then frequencyrange=[frequency[0],frequency[nf-1]]
  iif = where(frequency ge frequencyrange[0] and frequency le frequencyrange[1])

  pmdd = reform(power)
  pmdd = pmdd(iif)
  fdd = frequency(iif)
  iiip = where(pmdd eq max(pmdd),cccp) ; maximum power over the frequency range
  if cccp gt 0 then begin
      dominantfreq = fdd[iiip[0]]
      dominantpower = pmdd[iiip[0]]
  endif else begin
	  dominantfreq = 0
	  dominantpower = 0
  endelse
  
return, dominantfreq

end