barplot( h.entropy.48.c$counts * c(1: 8) - h.entropy.48.abca$counts * c(1:8),type="o", 
     ylab='Count',xlab='Moves',
     main='Entropy, Score difference per moves',
     sub='l=4, c=8, ABCD - ABCA')

