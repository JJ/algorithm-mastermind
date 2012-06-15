plot(tapply(X=(cset.most1.4.8$Played), INDEX=list(cset.most1.4.8$Evaluations), FUN=mean),type="l", lty='dashed',
     ylab='Average size',xlab='Moves',
     main='Remaining combinations, average size',
     col='red',log='y')
lines(tapply(X=(cset.entropy.4.8$Played), INDEX=list(cset.entropy.4.8$Evaluations), FUN=mean),col='black')
