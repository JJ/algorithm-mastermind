cga.evorank.df <-data.frame( params= c(rep('0-CGA-p128',12960), rep('1-CGA-p256',12960), rep('2-CGA-p500-r06',12960), rep('3-evorank-p400',12960)),evals=c( cga.partitions.p128$Evaluations, cga.partitions.p256$Evaluations, cga.partitions.p500$Evaluations, evorank.p400$Evaluations ), played=c(cga.partitions.p128$Played,cga.partitions.p256$Played, cga.partitions.p500$Played, evorank.p400$Played ))

cga.evorank.mean <-data.frame(params= c('0-CGA-p128','1-CGA-p256','2-CGA-p500-r06','3-evorank-p400'),evals=c( mean(cga.partitions.p128$Evaluations), mean(cga.partitions.p256$Evaluations), mean(  cga.partitions.p500$Evaluations), mean( evorank.p400$Evaluations )), played=c(mean(cga.partitions.p128$Played), mean(cga.partitions.p256$Played), mean(  cga.partitions.p500$Played), mean( evorank.p400$Played )))

boxplot( cga.evorank.df$played ~ cga.evorank.df$params )
lines( cga.evorank.mean$played ~ cga.evorank.mean$params, col='red' )
points( cga.evorank.mean$played ~ cga.evorank.mean$params, col='red' )

boxplot( cga.evorank.df$evals ~ cga.evorank.df$params, log='y' )
lines( cga.evorank.mean$evals ~ cga.evorank.mean$params, col='red' )
points( cga.evorank.mean$evals ~ cga.evorank.mean$params, col='red' )

