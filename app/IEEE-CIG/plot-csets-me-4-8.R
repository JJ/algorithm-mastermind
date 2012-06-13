plot(tapply(X=(cset.most.4.8$Played), INDEX=list(cset.most.4.8$Evaluations), FUN=mean),type="l", lty='dashed',
     ylab='Average size',xlab='Moves',
     main='Remaining combinations',
     col='red',
     sub='histogram',log='y')
lines(tapply(X=(cset.entropy.4.8$Evaluations), INDEX=list(cset.entropy.4.8$Played), FUN=mean),col='black')
