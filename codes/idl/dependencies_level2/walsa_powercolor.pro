pro walsa_powercolor, number

filedir = file_which('walsa_powercolor.pro')
slen = strlen(filedir)
prodir = strmid(filedir, 0, slen-20)

if number eq 1 then userlct,/full,verbose=0,coltab=nnn 
if number eq 2 then begin
	customclt = walsa_readtext(prodir+'color_tables/customct2.txt')
	R = ((reform(customclt[0,*]))/max(reform(customclt[0,*])))*255
	G = ((reform(customclt[1,*]))/max(reform(customclt[1,*])))*255
	B = ((reform(customclt[2,*]))/max(reform(customclt[2,*])))*255
	tvlct, R, G, B
endif
if number eq 3 then begin
	customclt = walsa_readtext(prodir+'color_tables/customct3.txt')
	R = ((reform(customclt[0,*]))/max(reform(customclt[0,*])))*255
	G = ((reform(customclt[1,*]))/max(reform(customclt[1,*])))*255
	B = ((reform(customclt[2,*]))/max(reform(customclt[2,*])))*255

	colnum = n_elements(R)
	colors = fltarr(3,colnum)

	colors[0,*] = R
	colors[1,*] = G
	colors[2,*] = B
	
	ctb0 = COLORTABLE(colors, NCOLORS=colnum)
	ctb = CONGRID(ctb0, 256, 3)

	R = reform(ctb[*,0])
	G = reform(ctb[*,1])
	B = reform(ctb[*,2])
	
	tvlct, R, G, B
endif

end