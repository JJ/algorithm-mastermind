plot(h.entropy1.4.6.all$counts ~ c(1:7),type="l",
     ylab='Count',xlab='Moves',
     main='Times solved after N moves')
lines(h.most1.4.6.all$counts ~ c(1:7),col='red',lty='dashed')
