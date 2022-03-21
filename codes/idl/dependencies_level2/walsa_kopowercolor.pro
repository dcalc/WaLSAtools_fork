pro walsa_kopowercolor, number
	
if number eq 1 then userlct,/full,verbose=0,coltab=nnn 
if number eq 2 then begin
	filedir = file_which('walsa_kopowercolor.pro')
	slen = strlen(filedir)
	prodir = strmid(filedir, 0, slen-22)
	koclt = walsa_readtext(prodir+'kocustomcolor1.txt')
	R = ((reform(koclt[0,*]))/max(reform(koclt[0,*])))*255
	G = ((reform(koclt[1,*]))/max(reform(koclt[1,*])))*255
	B = ((reform(koclt[2,*]))/max(reform(koclt[2,*])))*255
	tvlct, R, G, B
endif

end