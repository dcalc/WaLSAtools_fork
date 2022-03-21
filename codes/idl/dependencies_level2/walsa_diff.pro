function walsa_diff, array
  ; calculate differences between consecutive numbers in an array (the sampling space)
  num = n_elements(array)
  diff = dblarr(num-1)
  for i=0L, num-2 do diff[i] = array[i+1]-array[i]

  return, diff
end