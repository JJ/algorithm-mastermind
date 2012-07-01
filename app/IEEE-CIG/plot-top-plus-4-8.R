plot(tapply(X=(cset.in.most.48.c$IsIn), INDEX=list(cset.in.most.48.c$Move), FUN=mean),type="o", lty='dashed',
     ylab='Probability',xlab='Moves', ylim=c(0,1),
     main='Prob. secret code in top scorers', sub='l=4, c=8',
     col='red')

lines(tapply(X=(cset.in.plus2.48.c$IsIn), INDEX=list(cset.in.plus2.48.c$Move), FUN=mean),col='brown',lty='dotdash',type="o")
lines(tapply(X=(cset.in.entropy.48.c$IsIn), INDEX=list(cset.in.entropy.48.c$Move), FUN=mean),col='black',type="o")
