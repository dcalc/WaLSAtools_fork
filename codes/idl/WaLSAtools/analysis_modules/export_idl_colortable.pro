pro export_idl_colortable, n, file=file, enhancefactor=enhancefactor, minshift=minshift, maxshift=maxshift
	
	loadct, n, /SILENT

	TVLCT, r, g, b, /GET
	
	
	if n_elements(enhancefactor) ne 0 then begin
		; Adjust RGB values to stretch colors to the left (reduce white dominance on the left)
		; Raising to a power. 'enhancefactor' slightly less than 1 darkens the low end.
		r = BYTSCL(r ^ enhancefactor)
		g = BYTSCL(g ^ enhancefactor)
		b = BYTSCL(b ^ enhancefactor)
		TVLCT, r, g, b
	endif
	
	if n_elements(minshift) ne 0 AND n_elements(maxshift) ne 0 then begin
		; Stretch colors toward the right by redistributing color values.
		; Map the colors to start, e.g., higher in the range, [75, 255], instead of [0, 255]
		; -- or the other way around: [minshift, maxshift] = [10, 180]
		r = BYTSCL(r, MIN=minshift, MAX=maxshift)
		g = BYTSCL(g, MIN=minshift, MAX=maxshift)
		b = BYTSCL(b, MIN=minshift, MAX=maxshift)
		TVLCT, r, g, b
	endif
	
	a = fltarr(3,256)
	a(0,*)=R & a(1,*)=G & a(2,*)=B
	write_text_sj, a, file
	
	print
	print, '.... saved color table as '+file
	print
	
stop
end