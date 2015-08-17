# File: main.R
# Auth: u.niazi@imperial.ac.uk
# Date: 17/08/2015
# Desc: data from alice/ami for randomization hiv

iExp = 3
iSam.size.1 = 2
iSam.size.2 = 3

d1 = as.character(dos.1)
d2 = as.character(dos.2)

l = vector('list', iExp)
names(l) = c(paste('Experiment', 1:iExp, sep = '.'))

for(i in seq_along(l)){
  lsam = sample(seq_along(d1), iSam.size.1, replace = F)
  d1.sam = d1[lsam]
  d1 = d1[-lsam]
  
  lsam = sample(seq_along(d2), iSam.size.2, replace = F)
  d2.sam = d2[lsam]
  d2 = d2[-lsam]
  
  l[[i]] =  data.frame(samples=c(d1.sam, d2.sam), labels=c('d1', 'd1', 'd4', 'd4', 'd4'))
}

dfExport = do.call(rbind, l)