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
iExpCount = 14
# samples in each experiment
iSampleCount = nrow(dfDat)/iExpCount

# group count in each experiment
ivGrp = ceiling(iSampleCount * ivProp)
# maximum experiments possible with all three groups
iMax = min(as.vector(table(fDos)))

# Generate randomized data for each experiment
dfDat.grp = dfDat
# indices for each group of dos
ivDos.1 = which(dfDat.grp$Dosanjh == 1)
ivDos.2 = which(dfDat.grp$Dosanjh == 2)
ivDos.4 = which(dfDat.grp$Dosanjh == 4)

# create a list for with experiment ids for each experiment
set.seed(123)
lExp = vector('list', length = iExpCount)
#names(lExp) = paste('Experiment.', 1:iMax, sep='')

for (i in 1:iMax){
  #if (length(ivDos.2) < ivGrp['2'] || length(ivDos.1) < ivGrp['1'] || length(ivDos.4) < ivGrp['4']) break
  s1 = sample(ivDos.1, size = ivGrp['1'], replace = F)
  s2 = ifelse(length(ivDos.2) == 1, ivDos.2, sample(ivDos.2, size = ivGrp['2'], replace = F))
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

# divide the 2 last groups into 5 and 4
ivDos.1 = which(dfDat.grp$Dosanjh == 1)
ivDos.4 = which(dfDat.grp$Dosanjh == 4)
s1 = sample(ivDos.1, size = 2, replace = F)
s4 = sample(ivDos.4, size = 3, replace = F)
lExp[[iMax+1]] = dfDat.grp[c(s1, s4), ]
# remove these rows from the data frame before taking next sample
dfDat.grp = dfDat.grp[-c(s1, s4),]

lExp[[iMax+2]] = dfDat.grp
lExp[sapply(lExp, is.null)] = NULL


lapply(seq_along(lExp), function(x) write.csv(lExp[[x]], file=paste('experiment', x, '.csv', sep='')))


