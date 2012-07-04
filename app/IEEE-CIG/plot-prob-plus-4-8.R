plot(tapply(X=(cset.prob.entropy.48.c$IsIn), INDEX=list(cset.in.entropy.48.c$Move), FUN=mean),type="o", 
     ylab='Probability',xlab='Moves (+1)', ylim=c(0,0.6),
     main='Prob drawing secret code ', sub='l=4, c=8')
lines(tapply(X=(cset.prob.most.48.c$Prob), INDEX=list(cset.prob.most.48.c$Move), FUN=mean),col='red',lty='dashed',type="o")
lines(tapply(X=(cset.prob.plus2.48.c$IsIn), INDEX=list(cset.prob.plus2.48.c$Move), FUN=mean),col='brown',lty='dotdash',type="o")
