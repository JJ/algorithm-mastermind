plot(h.entropy1.4.6.all$counts ~ c(0:7),type="l",
     ylab='Count',xlab='Moves',
     main='Number of moves to solution',
     sub='histogram')
lines(h.most1.4.6.all$counts ~ c(0:7),col='red',lty='dashed')
