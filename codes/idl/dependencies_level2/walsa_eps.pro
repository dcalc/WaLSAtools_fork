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
