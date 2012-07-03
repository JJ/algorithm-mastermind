plot(h.entropy.48.c$counts ~ c(1:8),type="o",
     ylab='Games',xlab='Moves',
     main='Times solved after N moves', sub='l=4, c=8')
lines(h.most.48.c$counts ~ c(1:8),col='red',lty='dashed', type='o')
