# Name: Sample_randomisation_Long.R
# Auth: u.niazi@imperial.ac.uk
# Date: 11/06/2015
# Desc: Randomization of data for PCR

# read the data
dfDat = read.csv(file.choose(), header=T)

f = as.character(dfDat$Diagoutcome)
fGroups = rep(NA, length=length(f))
# create factors
i = grep('Active TB', x = f)
fGroups[i] = 'ATB'
fGroups[-i] = 'OD'
fGroups = factor(fGroups, levels = c('OD', 'ATB'))

dfDat$fGroups = fGroups

# randomly select indices of ATB and OD
i.atb = which(dfDat$fGroups == 'ATB')
i.od = which(dfDat$fGroups == 'OD')

# randomly select 150 from each group
r.atb = sample(i.atb, size = 150, replace = F)
r.od = sample(i.od, size = 150, replace = F)

# mix the numbers
i = c(r.atb, r.od)
i = sample(i, size = length(i), replace = F)

# save results
dfDat.Random = dfDat[i,]
write.csv(dfDat.Random, file='Data_output/Sample_randomized_Long.csv')


