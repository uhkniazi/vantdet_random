# read the data
dfDat = read.csv(file.choose(), header=T, sep='\t')

# subset only the hiv negative
dfDat = dfDat[!dfDat$HIVStatus,]

fDos = dfDat$Dosanjh
table(fDos)
ivProp = as.vector(table(fDos))
names(ivProp) = c('1', '2', '4')
ivProp = ivProp/sum(ivProp)

# number of experiments
iExpCount = 5
# samples in each experiment
iSampleCount = nrow(dfDat)/iExpCount

# group count in each experiment
ivGrp = iSampleCount * ivProp

# Generate randomized data for each experiment
dfDat.grp = dfDat
# indices for each group of dos
ivDos.1 = which(dfDat.grp$Dosanjh == 1)
ivDos.2 = which(dfDat.grp$Dosanjh == 2)
ivDos.4 = which(dfDat.grp$Dosanjh == 4)

# create a list for with experiment ids for each experiment
set.seed(123)
lExp = vector('list', length = iExpCount)
names(lExp) = paste('Experiment.', 1:iExpCount, sep='')

for (i in 1:iExpCount){
  s1 = sample(ivDos.1, size = ivGrp['1'], replace = F)
  s2 = sample(ivDos.2, size = ivGrp['2'], replace = F)
  s4 = sample(ivDos.4, size = ivGrp['4'], replace = F)
  # combine the indices to get the ids
  lExp[[i]] = dfDat.grp[c(s1, s2, s4), ]
  # remove these rows from the data frame before taking next sample
  dfDat.grp = dfDat.grp[-c(s1, s2, s4),]
  # get the new indices to sample again
  ivDos.1 = which(dfDat.grp$Dosanjh == 1)
  ivDos.2 = which(dfDat.grp$Dosanjh == 2)
  ivDos.4 = which(dfDat.grp$Dosanjh == 4)
}

lapply(seq_along(lExp), function(x) write.csv(lExp[[x]], file=paste(names(lExp)[x], '.csv', sep='')))


