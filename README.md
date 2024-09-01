# Prédiction de la Date de Maturation du Merlot

Ce projet, réalisé en collaboration avec Ulrich Karl ODJO dans le cadre de l'unité d'enseignement "Étude de cas, statistiques appliquées" en L3 MIASHS, vise à développer un modèle de prédiction de la date de maturation du cépage Merlot en fonction de variables climatiques et environnementales.

### Contexte

Les viticulteurs de Bordeaux ont étudié les conditions de développement et de maturation de leurs différents cépages en fonction des sols de leur terre, afin d'optimiser leurs cultures. Le Merlot est un cépage rouge qui représente plus de 65% de la surface plantée dans les terroirs bordelais. Il est à maturation lente, estimée à deux semaines et demie après le Chasselas. Les sols les plus adaptés à une maturation lente sont les sols argilo-calcaires frais. Cependant, les viticulteurs ont constaté que la date de maturation du Merlot peut varier considérablement d'une année à l'autre, ce qui complique la logistique et la qualité du vin.

### Objectif

L'objectif principal de ce projet est de déterminer les facteurs qui ont un impact significatif sur la date de maturation du Merlot, afin de construire un modèle de prédiction fiable.

### Méthodologie

Les données historiques sur plusieurs années ont été collectées et utilisées pour entraîner et tester différents modèles statistiques. Le langage de programmation R a été utilisé pour l'analyse et la modélisation des données.

Le rapport décrit en détail les différentes étapes du projet, notamment :

- Introduction au Merlot et à son environnement
- Explication des variables utilisées dans l'analyse
- Analyse de corrélation entre les variables
- Analyse globale de la régression et sélection d'un sous-modèle
- Sélection d'un modèle parcimonieux
- Comparaison des modèles et choix du modèle final
- Prévision des dates de maturation pour les années 2001 à 2007

### Résultats

Le rapport présente les résultats de l'analyse, y compris les coefficients de corrélation, les résultats de régression et les prévisions de dates de maturation pour les années 2001 à 2007. Le modèle final choisi est un modèle de régression linéaire multiple qui prend en compte les variables NbJrs30JJ, NbJ25_30JJ, NbJ20_25JJ et SommeRayonnementJJ.

### Conclusion

Le projet a permis de construire un modèle de prédiction de la date de maturation du Merlot en fonction de variables climatiques et environnementales. Ce modèle peut aider les viticulteurs à planifier leur logistique et à optimiser la qualité de leur vin. Cependant, le modèle ne prend pas en compte les changements climatiques et les différents types de pollution, qui peuvent impacter le Merlot. Par conséquent, des mises à jour régulières du modèle seront nécessaires pour garantir sa pertinence dans le temps.

> Pour une lecture simplifiée du projet, une version PDF du rapport est disponible dans le dépôt GitHub.
