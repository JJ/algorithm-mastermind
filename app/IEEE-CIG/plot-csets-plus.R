plot(tapply(X=(cset.most.4.6$Played), INDEX=list(cset.most.4.6$Evaluations), FUN=mean),type="l", lty='dashed',
     ylab='Average size',xlab='Moves',
     main='Remaining combinations',
     col='red', log='y')
lines(tapply(X=(cset.plus.4.6$Played), INDEX=list(cset.plus.4.6$Evaluations), FUN=mean),col='green',lty='dotted')
lines(tapply(X=(cset.entropy.4.6$Played), INDEX=list(cset.entropy.4.6$Evaluations), FUN=mean),col='black')
