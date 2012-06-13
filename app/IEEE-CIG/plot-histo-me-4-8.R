plot(h.entropy1.4.8$counts ~ c(1:9),type="l",
     ylab='Count',xlab='Moves',
     main='Number of moves to solution, l=4, K=8',
     sub='histogram')
lines(h.most1.4.8$counts ~ c(1:9),col='red',lty='dashed')
