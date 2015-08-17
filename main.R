# File: main.R
# Auth: u.niazi@imperial.ac.uk
# Date: 17/08/2015
# Desc: data from alice/ami for randomization

iExp = 4
iSam.size = 5

d1 = as.character(dfData$dos.1)
d2 = as.character(dfData$dos.2)

l = vector('list', iExp)
names(l) = c(paste('Experiment', 1:iExp, sep = '.'))

for(i in seq_along(l)){
  lsam = sample(seq_along(d1), iSam.size, replace = F)
  d1.sam = d1[lsam]
  d1 = d1[-lsam]
  
  lsam = sample(seq_along(d2), iSam.size, replace = F)
  d2.sam = d2[lsam]
  d2 = d2[-lsam]
  
  l[[i]] =  data.frame(d1.sam, d2.sam)
}

dfExport = do.call(rbind, l)