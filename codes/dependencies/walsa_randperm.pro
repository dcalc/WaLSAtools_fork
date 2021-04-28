function walsa_randperm, numberOfElements, SEED=seed
  x = Lindgen(numberOfElements)
  return, x[Sort(Randomu(seed, numberOfElements))]
end