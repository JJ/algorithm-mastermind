plot(h.entropy.48.c$counts ~ c(1:8),type="o",
     ylab='Count',xlab='Moves',
     main='Histogram: moves to solution, l=4 K=8')
lines(h.most.48.c$counts ~ c(1:8),col='red',lty='dashed', type='o')
