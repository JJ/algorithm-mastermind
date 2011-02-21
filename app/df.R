evorank.df <-data.frame( params=c(rep('0-p128-r025',12960), rep('1-p128',12960), rep('2-p128-p075',12960), rep('3-p256-r05',12960), rep('4-p400',12960), rep('5-p500-r06',12960), rep('6-p500',12960)),evals=c( evorank.p128.r025$Evaluations,  evorank.p128$Evaluations, evorank.p128.p075$Evaluations, evorank.p256.r05$Evaluations,  evorank.p400$Evaluations, evorank.p500.r06$Evaluations, evorank.p500$Evaluations), played=c( evorank.p128.r025$Played,  evorank.p128$Played, evorank.p128.p075$Played, evorank.p256.r05$Played,  evorank.p400$Played, evorank.p500.r06$Played, evorank.p500$Played))

evorank.mean <-data.frame( params=c('1-p128-r025','2-p128','3-p128-p075','4-p256-r05','5-p400','6-p500-r06','7-p500'),evals=c( mean(evorank.p128.r025$Evaluations), mean(  evorank.p128$Evaluations ), mean( evorank.p128.p075$Evaluations ), mean( evorank.p256.r05$Evaluations ), mean(  evorank.p400$Evaluations ), mean( evorank.p500.r06$Evaluations ), mean( evorank.p500$Evaluations) ), played=c( mean(evorank.p128.r025$Played), mean(  evorank.p128$Played ), mean( evorank.p128.p075$Played ), mean( evorank.p256.r05$Played ), mean(  evorank.p400$Played ), mean( evorank.p500.r06$Played ), mean( evorank.p500$Played)) )

boxplot( evorank.df$evals ~ evorank.df$params, log='y' )
lines( evorank.mean$evals ~ evorank.mean$params, col='red' )
points( evorank.mean$evals ~ evorank.mean$params, col='red' )

boxplot( evorank.df$played ~ evorank.df$params )
lines( evorank.mean$played ~ evorank.mean$params, col='red' )
points( evorank.mean$played ~ evorank.mean$params, col='red' )
