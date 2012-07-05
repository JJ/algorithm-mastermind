plot(tapply(X=(csets.entropy.48.abca$Played), INDEX=list(csets.entropy.48.abca$Evaluations), FUN=mean),type="o", lty='twodash',
     ylab='Average size',xlab='Moves',
     main='Remaining combinations, average size',
     col='black',log='y')

lines(tapply(X=(cset.entropy.48.c$Played), INDEX=list(cset.entropy.48.c$Evaluations), FUN=mean),col='black', type='o')
