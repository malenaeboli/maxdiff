library("support.BWS")
library("crossdes")
library("mlogit")
#ahora vamos a fitear el modelo con funcion mlogit(). vamos a usar solo los argumentos
#formula y data
mf <- RES ~ origin + variety + price + taste + safety + milling - 1
#el dataset creado por bws.dataset() necesita ser convertido a S3 class mlogit data
#con la funcion mlogit.data() en el paquete mlogit.
# Data set for the maxdiff model
md.data.ml <- mlogit.data(data = md.data, choice = "RES", shape = "long",
                          alt.var = "PAIR", chid.var = "STR", id.var = "id")
md.out <- mlogit(formula = mf, data = md.data.ml)
summary(md.out)
#calculate shares
sp.md <- bws.sp(md.out, base = "washfree")
sp.md
#codigo fit random parameter logit
rpl1 <- mlogit(
  formula = RES ~ origin + variety + price + taste + safety + milling - 1| 0,
  data = md.data.ml, 
  rpar = c(origin = "n", variety = "n", price = "n", taste = "n", safety = "n",
           milling = "n"),
  R = 100, halton = NA, panel = TRUE)
summary(rpl1)

#para qeu te reporte utilidades individuales (Creo  )
indpar <- fitted(rpl1, type = "parameters")
head(indpar)
