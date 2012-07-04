plot(tapply(X=(prob.entropy.46$Prob), INDEX=list(prob.entropy.46$Move), FUN=mean),type="o", 
     ylab='Probability',xlab='Moves+2', ylim=c(0,0.6), xlim=c(1,5),
     main='Prob drawing secret code ', sub='l=4, c=6')
lines(tapply(X=(prob.most.46$Prob), INDEX=list(prob.most.46$Move), FUN=mean),type="o", col='red',lty='dashed' )
lines(tapply(X=(prob.plus2.46$Prob), INDEX=list(prob.plus2.46$Move), FUN=mean),col='blue',lty='dotdash',type="o")
lines(tapply(X=(prob.plus.46$Prob), INDEX=list(prob.plus.46$Move), FUN=mean),col=73,lty='dotted',type="o")
