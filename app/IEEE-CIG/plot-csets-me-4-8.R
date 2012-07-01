plot(tapply(X=(cset.most.48.c$Played), INDEX=list(cset.most.48.c$Evaluations), FUN=mean),type="o", lty='dashed',
     ylab='Average size',xlab='Moves',
     main='Remaining combinations, average size',
     col='red',log='y')
lines(tapply(X=(cset.entropy.48.c$Played), INDEX=list(cset.entropy.48.c$Evaluations), FUN=mean),col='black',type='o')
