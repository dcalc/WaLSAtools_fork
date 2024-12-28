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
; NAME:
; walsa_curvefill
;
; PURPOSE:
;    Shade the region between two curves
;
; CALLING SEQUENCE:
;      wtcurvefill, x, y1, y2, COLOR=, OUTLINECOLOR=, OUTHICK=
;   
; INPUTS:
;  x -- x-values of the curve
;  y1 -- lower set of y-values
;  y2 -- upper set of y-values
;
; RETURNS:
;
; OUTPUTS:
;
; OPTIONAL KEYWORDS:
; color=  -- Color for shading
; /LINE_FILL -- Hashes instead of fills
; ORIENTATION -- Sets the angle of the lines
; /xyreverse -- Lets you fill based on x rather than y
;               ie: x->y, y1->x1, y2->x2 
; x2=  -- Lets you input a second array specifying both x1 and x2.
;
;------------------------------------------------------------------------------
pro walsa_curvefill, x, y1, y2, color = color, outlinecolor = outlinecolor $
                 , _EXTRA = EXTRA, OUTHICK = OUTHICK, xyreverse=xyreverse, x2=x2

  if  N_params() LT 3  then begin 
    print,'Syntax - ' + $
             'walsa_curvefill, x, y1, y2, COLOR=, /LINE_FILL, ORIENTATION= [v1.1]'
    return
  endif 

  n1 = n_elements(x)
  IF n_elements(y1) NE n1 OR n_elements(y2) NE n1 or $
    N_elements(y1) NE n_elements(y2) THEN message, 'problem with array sizes'

  if keyword_set(xyreverse) then begin
     ;; Create a polygon to fill from x values
     xpoly = [y1[0], y2, reverse(y1)]
     ypoly = [x[0], x, reverse(x)]
  endif else begin
     ;; Create a polygon to fill from y values (original code)
     xpoly = [x[0], x, reverse(x)]
     ypoly = [y1[0], y2, reverse(y1)]
  endelse 
  
  ; This is in case you have two curves with different x1, x2, y1, y2
  ; If this is specified, it overwrites the polygons from anything before.
  if keyword_set(x2) then begin
     if n_elements(x2) ne n_elements(x) then message, 'problem with array sizes'
     x1 = x
     xpoly=[x1[0], x2, reverse(x1)]
     ypoly=[y1[0], y2, reverse(y1)]
  endif
  
  PolyFill, xpoly, ypoly, Color = color, NOCLIP = 0, _EXTRA = EXTRA
  
  IF n_elements(OUTLINECOLOR) NE 0 THEN $
    plots, xpoly, ypoly, Color = outlineColor, Thick = OUTHICK, NOCLIP = 0
  return
  
END