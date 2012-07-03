plot(h.entropy1.4.6.all$counts ~ c(1:7),type="o",
     ylab='Games',xlab='Moves',
     main='Times solved after N moves',
     sub='l=4, c=6')
lines(h.most1.4.6.all$counts ~ c(1:7),col='red',lty='dashed',type='o')
