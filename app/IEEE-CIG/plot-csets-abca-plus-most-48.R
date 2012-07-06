plot(tapply(X=(cset.most.48.c$Played), INDEX=list(cset.most.48.c$Evaluations), FUN=mean),type="o", lty='twodash',
     ylab='Average size',xlab='Moves',
     main='Remaining combinations, average size', sub='Most Parts (ABCD) vs. Plus(ABCA)',
     col='red',log='y')

lines(tapply(X=(csets.plus2.48.abca$Played), INDEX=list(csets.plus2.48.abca$Evaluations), FUN=mean),col='brown', type='o',lty='longdash')
