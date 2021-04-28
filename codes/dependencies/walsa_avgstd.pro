FUNCTION walsa_avgstd, array, stdev=stdev
    ; get array average & standard deviation
    ; based on a recipe from Rob Rutten
  avrg = total(array)/n_elements(array)
  stdev = sqrt(total((array-avrg)^2)/n_elements(array))
  return, avrg
end