plot(tapply(X=(csets.entropy.48.abca$Played), INDEX=list(csets.entropy.48.abca$Evaluations), FUN=mean),type="o", lty='dashed',
     ylab='Average size',xlab='Moves',
     main='Remaining combinations, average size',
     col='red',
     log='y' )
lines(tapply(X=(csets.plus2.48.abca$Played), INDEX=list(csets.plus2.48.abca$Evaluations), FUN=mean),col='brown', lty='dotdash', type='o')

