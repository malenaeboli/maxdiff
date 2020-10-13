#support.BWS (Aizaki 2018), crossdes (Sailer 2013), and mlogit (Croissant 2013)-to explain how to implement Case 1 BWS in R. 

#install.packages(c("crossdes","mlogit","support.BWS"),repos = c("https://cran.rstudio.com/"),dep = TRUE)
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
