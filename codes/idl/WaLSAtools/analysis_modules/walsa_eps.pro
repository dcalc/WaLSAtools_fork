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
; NAME:     eps
;
; PURPOSE:  Save plots below this command to fig_out.eps in Desktop (on a MacBook)
;           
; KEYWORDS:
; SIZE:     in cm in this format: [x,y]
;           Default: [22.,20.]
; 
;
;  Created by Shahin Jafarzadeh
;-
pro walsa_eps, size=size

    if keyword_set(size) eq 0 then size=[20.,22.]
    file = './fig_out.eps'
    psset, ps=1, size=size, file=file, /encaps, /no_x

end
