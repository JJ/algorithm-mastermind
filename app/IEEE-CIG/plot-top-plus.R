plot(tapply(X=(cset.in.most1.4.6$IsIn), INDEX=list(cset.in.most1.4.6$Move), FUN=mean),type="l", lty='dashed',
     ylab='Probability',xlab='Moves', ylim=c(0,1),
     main='Probability secret code in top scorers',
     col='red')
lines(tapply(X=(cset.in.plus.4.6$IsIn), INDEX=list(cset.in.plus.4.6$Move), FUN=mean),
      col='blue',lty='dotted')
lines(tapply(X=(cset.in.plus2.4.6$IsIn), INDEX=list(cset.in.plus2.4.6$Move), FUN=mean),
      col='brown',lty='dotdash')
lines(tapply(X=(cset.in.entropy1.4.6$IsIn), INDEX=list(cset.in.entropy1.4.6$Move), FUN=mean),col='black')
