function walsa_mode,input,binsize=binsize
  ; get statistical mode of an array
  h = histogram(input,binsize=binsize,omin=omin)
  if not(keyword_set(binsize)) then binsize=1
  mh = max(h)
  i = where(h eq max(h))
  iout = i*binsize+omin

  return,iout[0]
end