plot(tapply(X=(cset.most.4.6$Played), INDEX=list(cset.most.4.6$Evaluations), FUN=mean),type="l", lty='dashed',
     ylab='Average size',xlab='Moves',
     main='Remaining combinations',
     col='red',
     sub='histogram',log='y')
lines(tapply(X=(cset.entropy.4.6$Played), INDEX=list(cset.entropy.4.6$Evaluations), FUN=mean),col='black')
