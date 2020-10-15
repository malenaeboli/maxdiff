library("support.BWS")
library("crossdes")
library("mlogit")
#acount analysis. 
#bws.count() calcula el best best-worst and standarized scores for each respondent
#tiene dos argumentos data y cl. un df generado de la funcion bws.dataset()
#si cl=1 retorna objeto de clase s3 bws.count contiene scores disagregados y agregados
#en formato lista. cl=2 clase S3 bws.count2 tiene todo lo mismo de antes mas variables heredadas del df original
load("rda/md.data.rda")
cs <- bws.count(md.data, cl = 2)
par(mar = c(5, 4, 2, 1))
barplot(cs, score = "bw")
dim(cs)
names(cs)
attributes(cs)
sum(cs)
summary(cs)
save(cs,file="rda/cs.rda")
