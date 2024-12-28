function cad, time
; calculate cadence

cadence = median(sjdiff(time,/silent))

return, cadence
end