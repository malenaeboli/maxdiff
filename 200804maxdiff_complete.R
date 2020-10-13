
#support.BWS (Aizaki 2018), crossdes (Sailer 2013), and mlogit (Croissant 2013)-to explain how to implement Case 1 BWS in R. 

install.packages(c("crossdes","mlogit","support.BWS"),repos = c("https://cran.rstudio.com/"),dep = TRUE)
library("support.BWS")
library("crossdes")
library("mlogit")
options(digits = 4)
#generar BIBD. funcion find.BIB()esta disponible para generar BIBD
#en este caso 7 tratamientos (items). 7 filas (Blocks/preguntas) 4 columnas (itemps por pregunta)
set.seed(8041) # a random seed value can be anything
des <- find.BIB(trt = 7, # seven treatments
                b = 7,   # seven rows
                k = 4)   # four columns
des
#usar isGYD() en el paqeute crossdes para chequear si el disenio es un BIBD
isGYD(des)
#abajo esta la lista limitada de configuraciones de BIBD
#trt=6 b=10 k=3. . trt=7 b=7 k=3. trt=9 b=12 k=6. trt=11 b=11 k=5. trt=13 b=13 k=4
#bws.questionare() convierte el disenio en una serie de preguntas que despliega en consola
#los nombres del vector lo guardo en items.rice
items.rice <- c("origin", "variety", "price", "taste", "safety", "washfree", "milling")
bws.questionnaire(choice.set = des, # dataframe or matrix containing a BIBD
                  design.type = 2,  # 2 if a BIBD is assgined to choice.set
                  item.names = items.rice) # names of items shown in question
#aca ya hay que hacer un survey con las preguntas puestas antes. 
#ahora vamos a generar respuestas y analizar
data("ricebws1", package = "support.BWS")
dim(ricebws1)
#en este caso son 90 personas
names(ricebws1)
#despues de conducir un survey necesitamos de las preguntas hacer un dataset con este formato
#si necesitas mas preguntas (como aca la edad y demas) van despues de las maxdiff
response.vars <- colnames(ricebws1)[2:15]
response.vars
# Dataset for the maxdiff model
md.data <- bws.dataset(
  respondent.dataset = ricebws1, # data frame containing response dataset
  response.type = 1, # format of response variables: 1 = row number format
  choice.sets = des, # choice sets
  design.type = 2, # 2 if a BIBD is assgined to choice.sets
  item.names = items.rice, # the names of items
  id = "id", # the name of respondent id variable
  response = response.vars, # the names of response variables
  model = "maxdiff") # the type of dataset created by the function is the maxdiff model
dim(md.data)
#este df tiene 7560 filas. Son 90 personas x 7 preguntas x 12 parejas por pregunta (4x3)
md.data[1:12, ]
#cada fila es para un posible par en RES marca si el par fue considerado en esta pregunta
#ahora haremos count analysis. para una descripcion. luego vamos a modelar.
#bws.count() calcula el best best-worst and standarized scores for each respondent
#tiene dos argumentos data y cl. un df generado de la funcion bws.dataset()
#si cl=1 retorna objeto de clase s3 bws.count contiene scores disagregados y agregados
#en formato lista. cl=2 clase S3 bws.count2 tiene todo lo mismo de antes mas variables heredadas del df original
cs <- bws.count(md.data, cl = 2)
par(mar = c(5, 4, 2, 1))
barplot(cs, score = "bw")
dim(cs)
names(cs)
attributes(cs)
sum(cs)
summary(cs)
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



