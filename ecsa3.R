######################################################################## 
# Importation des libraries
######################################################################## 
library(tidyverse)
library(readxl)
library(corrplot)
library(kableExtra)
library(leaps)
library(lubridate)

theme_set(
  theme_classic()
)

######################################################################## 
# Importation des données
######################################################################## 
vigne <- read_excel("ECSA3_vignobles_bordelais2022.xlsx", sheet=2) 
# Suppression de la variable redondante
vigne <- vigne %>% select(-c(MaMerlot...19))
# Renomme la première variable
vigne <- vigne %>% rename(MaMerlot=MaMerlot...2)

######################################################################## 
# Étude statistique
######################################################################## 
summary(vigne$floraison)
summary(vigne$Veraison)
summary(vigne$MaMerlot)

cor_matrix <- corrplot(cor(vigne, use="complete.obs"), tl.cex = 0.5,
                       number.cex = 0.5, order = "hclust", tl.col = "black",
                       col=COL2("PRGn"))

######################################################################## 
# Analyse globale de la regression
######################################################################## 

###
#### Analyse de la regression globale et selection d’un sous-model
###

# Modèle de regression globale
Mfull <- lm(MaMerlot ~ ., data = vigne) #summary(Mfull)

# Modèle 1
M1 <- lm(MaMerlot ~ Veraison + NbJ10_15JJ + NbJ10_15JuS +
           NbJ15_20JuS + NbJ20_25JuS, data = vigne)
summary(M1)

# Modèle 2
M2 <- lm(MaMerlot ~ NbJ20_25JJ + NbJrs30JuS + NbJ25_30JJ, data = vigne)
summary(M2)

###
#### Selection d'un modèle parcimonieux 
###

# Suppression de la variable floraison
vigne <- vigne %>% select(-c(floraison, NbJ10_15JuS))

# Recherche exhaustives des variables pertinentes pour les critères # Cp/AIC, BIC, R2_ajusté, RSS
modelfit.full <- regsubsets(MaMerlot ~ ., data = vigne, nvmax = 10)
model.full.summary <- summary(modelfit.full)

# Nombres de variables optimal pour chaque critères Cp, BIC, R2_ajusté
min.cp <- which.min(model.full.summary$cp)
min.bic <- which.min(model.full.summary$bic)
max.r2ajuste <- which.max(model.full.summary$adjr2)
print(min.cp)
print(min.bic)
print(max.r2ajuste)

# Valeurs du Cp pour chaque modèle de taille considéré
cp.val <- as.data.frame(model.full.summary$cp)
cp.val <- cp.val %>% mutate(index = seq(1, nrow(cp.val)))
cp.val <- cp.val %>% rename(cp = `model.full.summary$cp`)

# Représentation graphique
cp.val %>% arrange(cp) %>%
  ggplot(mapping = aes(x = index, y = cp)) +
  geom_line(color = "#E69F00") +
  geom_point(color = "#E69F00") +
  labs(title = "Cp",
       x = "Nombres de variables",
       y = "Cp")

# Valeurs du BIC pour chaque modèle de taille considéré
bic.val <- as.data.frame(model.full.summary$bic)
bic.val <- bic.val %>% mutate(index=seq(1, nrow(bic.val)))
bic.val <- bic.val %>% rename(bic=`model.full.summary$bic`)

# Représentation graphique
bic.val %>% arrange(bic) %>%
  ggplot(mapping = aes(x = index, y = bic)) +
  geom_line(color = "steelblue") +
  geom_point(color = "steelblue") +
  labs(title = "BIC",
       x = "Nombres de variables",
       y = "BIC")

# Valeurs du R2 ajusté pour chaque modèle de taille considéré
r2.val <- as.data.frame(model.full.summary$adjr2)
r2.val <- r2.val %>% mutate(index = seq(1, nrow(r2.val)))
r2.val <- r2.val %>% rename(r2 = `model.full.summary$adjr2`)

r2.val %>% arrange(r2) %>%
  ggplot(mapping = aes(x = index, y = r2)) +
  geom_line(color = "#E69F00") +
  geom_point(color = "#E69F00") +
  labs(title = "R2 ajusté",
       x = "Nombres de variables",
       y = "R2 ajusté")

# Listes des variables sélectionnées pour le critère Cp
names(which(model.full.summary$which[min.cp, ] == TRUE))

# Listes des variables sélectionnées pour le critère BIC
names(which(model.full.summary$which[min.bic, ] == TRUE))

# Listes des variables sélectionnées pour le critère R2_ajusté
names(which(model.full.summary$which[max.r2ajuste, ] == TRUE))

# Sélection de variables avec l'approche backward
modelfit.bwd <- regsubsets(MaMerlot ~ ., data = vigne,
                           method = "backward", nvmax = 18)
modelfit.bwd.sum <- summary(modelfit.bwd)

# Valeurs du Cp
cp.val.bwd <- as.data.frame(modelfit.bwd.sum$cp)
cp.val.bwd <- cp.val.bwd %>% mutate(index = seq(1, nrow(cp.val.bwd))) %>%
  rename(cp = `modelfit.bwd.sum$cp`)

# Nombre de variables minimisant le Cp par l'approche backward
min.cp.bwd <- which.min(modelfit.bwd.sum$cp)

cp.val.bwd %>% arrange(cp.val.bwd) %>%
  ggplot(mapping = aes(x = index, y = cp)) +
  geom_line(color = "steelblue") +
  geom_point(color = "steelblue") +
  labs(title = "Cp",
       x = "Nombres de variables",
       y = "Cp")

# Variables sélectionnées par l'approche backward
names(which(modelfit.bwd.sum$which[min.cp.bwd, ] == TRUE))

# Modèle obtenu par approche exhaustive sur critère Cp
summary(lm(MaMerlot ~ AN + NbJ10_15JJ + SommeTs10JJ + NbJ20_25JuS + Veraison, 
           data = vigne))

# Modèle obtenu par backward
summary(lm(MaMerlot ~ AN + NbJ20_25JuS + Veraison, data = vigne))

######################################################################## 
# Formule de prédiction pour les variables obtenus en Juin
######################################################################## 
# Récupère toutes les mesures de Janvier à Juins
vigne.jj <- vigne %>% select(contains("MaMerlot"), ends_with("JJ"))

# Modèle complet avec les variables de juin
modelfull.jj <- lm(MaMerlot ~ ., data = vigne.jj)
summary(modelfull.jj)

# Sélection de variable pour obtenir un meilleur modèle
modelbwd.jj <- regsubsets(MaMerlot ~ ., data = vigne.jj,
                          method = "backward", nvmax = 9)
modelbwd.jj.sum <- summary(modelbwd.jj)

# Nombre de variable minimisant le Cp
which.min(modelbwd.jj.sum$cp)

# Variables sélectionnés après minimisation du critère Cp
names(which(modelbwd.jj.sum$which[4, ] == TRUE))

# Estimation du modèle finale après sélection
modelfinal.jj <- lm(MaMerlot ~ NbJ25_30JJ + NbJ20_25JJ + SommeRayonnementJJ,
                    data = vigne.jj)
summary(modelfinal.jj)

######################################################################## 
# Prédiction pour les valeurs de 2001 à 2007
######################################################################## 
# Filtrage et selection des variable pour la prédiction
vigne.pred <- vigne %>%
  select(c(AN, MaMerlot, NbJrs30JJ, NbJ25_30JJ, NbJ20_25JJ, SommeRayonnementJJ)) %>%
  mutate(across(c(NbJrs30JJ, NbJ25_30JJ, NbJ20_25JJ, SommeRayonnementJJ),
                ~replace_na(., mean(., na.rm=TRUE)))) %>%
  filter(AN > 2000) %>% select(-c(MaMerlot))

# Affichage des valeurs à prédire
head(vigne.pred)

# Prévision des valeurs futurs
pred <- predict(modelfinal.jj, vigne.pred)

pred_date <- as.Date(gsub(" ", "", paste(as.character(vigne.pred$AN),
                                         "/01/01"))) + pred
names(pred_date) <- c("2001", "2002", "2003", "2004", "2005", "2006", "2007")
pred_date <- as.data.frame(pred_date) %>% rename(date_predite = pred_date)
pred_date$date_reel <- as.Date((c("2001-09-24", "2002-09-27", "2003-08-21",
                                  "2004-09-14", "2005-08-29", "2006-09-05",
                                  "2007-09-14")))
pred_date$erreur_absolue <- c(3, 1, 21, 9, 9, 14, 2)
kbl(pred_date, caption = "Prédiction du modèle") %>%
  kable_styling(bootstrap_options = "striped",
                full_width = F)

# Comparaison des valeurs observés et celles prédite
plotting_data <- data.frame(annee = vigne.pred$AN,
                            predite = pred,
                            reel = yday(pred_date$date_reel))

plotting_data %>% ggplot(mapping = aes(x = annee)) +
                        geom_line(aes(y = pred),
                                  color = "#9460D0") +
                        geom_line(aes(y = reel),
                                  color = "#65BE64") +
                        labs(x = "Date",
                             y = "Date de maturation") +
theme_minimal()
