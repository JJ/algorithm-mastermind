plot(cumsum(h.entropy1.4.6.all$counts) ~ c(1:7),type="o", 
     ylab='Count',xlab='Moves',
     main='Cumulative solutions after N moves',
     sub='l=4, c=6')
lines(cumsum(h.most1.4.6.all$counts) ~ c(1:7),col='red',lty='dashed',type='o')
