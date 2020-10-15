library("support.BWS")
library("crossdes")
library("mlogit")
load("rda/ricebws1.rda")
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
save(md.data,file="rda/md.data.rda")