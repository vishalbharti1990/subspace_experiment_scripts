get_NMI <- function(t){
  ## COMPUTE NMI sqrt FROM A CONTINGENCY TABLE
  normt = t/sum(t)
  rSum = rowSums(normt)
  cSum = colSums(normt)
  
  NMI = 0
  
  for(i in 1:dim(normt)[1]){
    for(j in 1:dim(normt)[2]){
      MI = normt[i,j] * log2(normt[i,j]/(rSum[i]*cSum[j]))
      if(!is.na(MI)){
        NMI = NMI + MI
      }
    }
  }
  
  log2R = log2(rSum)
  log2C = log2(cSum)
  
  s1 = -(rSum * log2R)
  s2 = -(cSum * log2C)
  
  s1[is.na(s1) || (s1 == -Inf)] = 0
  s2[is.na(s2) || (s2 == -Inf)] = 0
  
  h1 = sum(s1)
  h2 = sum(s2)
  
  NMI_sqrt = NMI/sqrt(h1*h2)
  NMI_min = NMI/min(h1,h2)
  NMI_max = NMI/max(h1, h2)
  NMI_sum = 2*NMI/(h1+h2)
  
  nmi= c(NMI_sqrt, NMI_min, NMI_max, NMI_sum)
  
  nmi[is.na(nmi)] = 0
  
  return(nmi) 
}