plot(tapply(X=(csets.5.8.p600.cs10$Played), INDEX=list(csets.5.8.p600.cs10$Evaluations), FUN=mean),type="o", lty='dashed',
     ylab='Average size',xlab='Moves',
     main='Actual Consistent Set Size', sub='l=5,k=8',
     col='red', log='y',ylim=c(1,160))
lines(tapply(X=(csets.5.8.p600.cs60$Played), INDEX=list(csets.5.8.p600.cs60$Evaluations), FUN=mean),col='green',lty='dotted',type='o')

