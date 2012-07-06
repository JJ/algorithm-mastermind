plot(tapply(X=(cset.prob.most.48.c$Prob), INDEX=list(cset.prob.most.48.c$Move), FUN=mean),
     ylab='Probability',xlab='Moves', ylim=c(0,0.6), type='o', col='red', lty='dotdash',
     main='Prob drawing secret code ', sub='Most(ABCD) vs. Plus2(ABCA)')

lines(tapply(X=(prob.plus2.48.abca$Prob), INDEX=list(prob.plus2.48.abca$Move), FUN=mean),lty='twodash',type="o",col='brown')
