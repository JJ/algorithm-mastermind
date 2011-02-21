boxplot( evorank.info$X.Consistent ~ evorank.info$Draw )
boxplot( cga.part.info$X.Consistent ~ cga.part.info$Draw, add=TRUE, boxcol='red', boxlty='dashed',  medcol='red', medlty='dashed', whiskcol='red', whisklty='dashed', staplecol='red', staplelty='dashed' )

boxplot( evorank.info$Entropy ~ evorank.info$Draw, ylim=c(3.5,6) )
boxplot( cga.part.info$Entropy ~ cga.part.info$Draw, add=TRUE, boxcol='red', boxlty='dashed',  medcol='red', medlty='dashed', whiskcol='red', whisklty='dashed', staplecol='red', staplelty='dashed' )
