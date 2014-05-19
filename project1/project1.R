# Voor deze opgave analyseren jullie gegevens afkomstig van de Vereniging
# van Vlaamse Steden en Gemeenten (http://www.vvsg.be). Deze vereniging
# brengt gegevens uit verschillende databanken samen en levert uitgebreide
# informatie over demografische en economische indicatoren per gemeente,
# regio, provincie, etc. Binnen het Vlaamse gewest worden 13 centrumsteden
# herkend, nl. Aalst, Antwerpen, Brugge, Genk, Gent, Hasselt,
# Kortrijk, Leuven, Mechelen, Oostende, Roeselare, Sint-Niklaas en Turnhout.
# Elke groep analyseert de gegevens van een regio bestaande uit een
# centrumstad en zijn omliggende gemeenten.

# De datasets bevatten de meest recente gegevens (afkomstig van 2011 of 2012)
# voor de volgende variabelen:

#+--------------+-------------------------------------------------------------+
#|              | Totaal aantal mannen                                        |
#|              | Totaal aantal vrouwen                                       |
#|              | Aantal geboorten                                            |
#| Demografisch | Aantal overlijdens                                          |
#|              | Immigratie saldo (Inwijkelingen-uitwijkelingen)             |
#|              | 80+/60+ verhouding (in%)                                    |
#|              | (0-19)/totaal verhouding (in %)                             |
#+--------------+-------------------------------------------------------------+
#|              | Aantal belastingsaangiften < 10.000 euro                    |
#|              | Aantal belastingsaangiften > 50.000 euro                    |
#| Economisch   | Gemiddeld inkomen per aangifte                              |
#|              | werkzaamheidsgraad (% werkenden van (18-64+) bevolking)     |
#|              | werkloosheidsgraad (% werkzoekenden van (18-64+) bevolking) |
#|              | Gemiddelde verkoopprijs van woonhuizen                      |
#+--------------+-------------------------------------------------------------+

# De groepen worden samengesteld tijdens het practicum.
# De datasets worden als volgt verdeeld:

#       +-------+---------+
#       | Groep | Dataset |
#       +-------+---------+
#       |   1   | Aalst   |
#       |   2   | Gent    |
#       |   3   | Hasselt |
#       |   4   | Kortrijk|
#       |   5   | Leuven  |
#       |   6   | Mechelen|
#       |   7   | Sint-   |
#       |       |  Niklaas|
#    ==>|   8   | Turnhout|
#       +-------+---------+

library(gdata)
turnhout = read.xls(xls='Turnhout.xlsx', sheet=1, pattern='Mannen')
rownames(turnhout) = turnhout[,1]
turnhout = turnhout[,-1]
colnames(turnhout) = c('Mannen',
                       'Vrouwen',
                       'n_geboorten',
                       'n_overlijdens',
                       'Immigratie saldo',
                       '80+/60+ (in%)',
                       '(0-19)/totaal (in %)',
                       'Aantal aangiften < 10.000 euro',
                       'Aantal aangiften > 50.000 euro',
                       'Gemiddeld inkomen per aangifte',
                       'Werkzaamheidsgraad',
                       'Werkloosheidsgraad',
                       'Gemiddelde verkoopprijs van woonhuizen')
for(column in 1:ncol(turnhout)) {
    turnhout[,column] = as.numeric(as.character(turnhout[,column]))
}

cat('\n ', 'Summary turnhout.xlsx:', '\n',
    '------------------------', '\n')
print(summary(turnhout))

# Opgave 1: PCA
#   1. Voer een PCA analyse uit op jullie gegevens. Argumenteer waarom je
#      de analyse baseert op de correlatie- of de covariantiematrix van de
#      gegevens. Bepaal het aantal componenten dat je verkiest te behouden
#      en verklaar je keuze.

pca_cov_turnhout = prcomp(turnhout, scale=FALSE)
pca_cor_turnhout = prcomp(turnhout, scale=TRUE)

cat('\n ', 'Pca on covariance matrix:', '\n',
    '---------------------------', '\n')
print(summary(pca_cov_turnhout))
#screeplot(pca_cov_turnhout, type='lines')

cat('\n ', 'Pca on correlation matrix:', '\n',
    '----------------------------', '\n')
print(summary(pca_cor_turnhout))
#screeplot(pca_cor_turnhout, type='lines')

### Kies de correlatie matrix omdat de schalen van de verschillende
### variabelen veel verschillen (aantallen, euros, procenten)
### Behoud 7 principale componenten, zo behouden we 98.6, ~99% van de
### informatie met ~1/2 van de variabelen.

#   2. Bekijk de loadings van de weerhouden componenten en tracht de PCs
#      te interpreteren aan de hand van de loadings. Ga na welke originele
#      variabelen het belangrijkst zijn voor elk van de weerhouden PCs.

cat('\n ', 'Loadings pca on correlation matrix:', '\n',
    '-------------------------------------', '\n')
print(pca_cor_turnhout$rotation[,1:7])

###   De eerste PC is ongeveer een gemiddelde waarbij de variabelen waarbij
### getelt wordt een groter gewicht hebben.
###     Aantal overlijdens (meeste met zeer weinig marge)
###   De tweede component bevat immigratie, de verhouding jonge mensen,
### de kostprijs van huizen en de verhouding 80+/60+:
### Immigranten zijn meestal jongere mensen of ze hebben veel kinderen;
### jongere mensen en de prijs van huizen zijn ook sterk verbonden, zij
### kunnen zich immers meestal geen dure villa's veroorloven.
###     Gemiddelde verkoopprijs van woonhuizen
###   PC3 bevat voornamelijk gemiddeld inkomen, werkzaamheidsgraad,
### werkloosheid, grote belastingaangiften en immigratie (ook 80+/60+).
### Een verband tussen werkzaamheid, werkloosheid, aangiften en inkomens is
### te verwachten. Immigratie gebeurt misschien vooral daar waar de lonen
### gunstig zijn.
###     Gemiddeld inkomen per aangifte
###   PC4 bestaat uit immigratie, verhouding jonge mensen, inkomen,
### werkloosheid en aantal geboorten.
### Nogmaals het verband tussen immigranten en jongeren, nu ook aantal
### geboorten. En ook, werkloosheid en inkomen.
###     Immigratie saldo
###   PC5 immigratie, 80+/60+, werkzaamheid, verkoopprijs, inkomen.
### Een verband tussen werkzaamheid, inkomen en verkoopprijs van huizen is te
### verwachten. Deze zijn ook gerelateerd aan de verhouding bejaarden en
### een beetje aan immigratie.
###     Werkzaamheidsgraad
###   PC6 immigratie, jonge mensen, inkomen, werkzaamheid, werkloosheid en
### verkoopprijs. Opnieuw het verband jonge mensen, immigratie. Ook, inkomen,
### verkoopprijs en immigratie, werkzaamheid, werkloosheid.
###     Gemiddelde verkoopprijs van woonhuizen
###   PC7 werkloosheid, werkzaamheid, inkomen, jonge mensen.
### Opnieuw jonge mensen, werkloosheid, werkzaamheid en inkomen.
###     Werkloosheidsgraad

#   3. Onderzoek de impact van de centrumstad op het resultaat van de PCA
#      analyse.

biplotmatrix = function (x, y, ...){
    par(new=TRUE)
    biplot(pca_cor_turnhout, c(x,y), pc.biplot=TRUE)
}

#pairs(t(seq(7)), panel=biplotmatrix)

### De eerste principaal component wordt gedicteerd door de centrumstad,
### Turnhout. De andere componenten worden nagenoeg niet beinvloed door de
### centrumstad. Dit is te verklaren aan de samenstelling van de PCs:
### De eerste PC bevat aantallen en die zijn voor een grote centrumstad
### groter, de andere PCs bestaan vooral uit verhoudingen en gemiddelden
### waarop de absolute hoeveelheid inwoners weinig invloed heeft.

# Opgave 2: Testen multivariate normaliteit
#   1. Onderzoek of de veronderstelling van multivariate normaliteit
#      aannemelijk zou zijn voor jullie gegevens. Gebruik hiervoor ook de
#      scores van de PCA analyse.

#par(mfrow=c(3,5))
#qqnorm(turnhout[,1])
#qqline(turnhout[,1])
#qqnorm(turnhout[,2])
#qqline(turnhout[,2])
#qqnorm(turnhout[,3])
#qqline(turnhout[,3])
#qqnorm(turnhout[,4])
#qqline(turnhout[,4])
#qqnorm(turnhout[,5])
#qqline(turnhout[,5])
#qqnorm(turnhout[,6])
#qqline(turnhout[,6])
#qqnorm(turnhout[,7])
#qqline(turnhout[,7])
#qqnorm(turnhout[,8])
#qqline(turnhout[,8])
#qqnorm(turnhout[,9])
#qqline(turnhout[,9])
#qqnorm(turnhout[,10])
#qqline(turnhout[,10])
#qqnorm(turnhout[,11])
#qqline(turnhout[,11])
#qqnorm(turnhout[,12])
#qqline(turnhout[,12])
#qqnorm(turnhout[,13])
#qqline(turnhout[,13])

### Univariate marginalen: het aantal mannen, vrouwen, geboorten, overlijdens
### en kleine belastingaangiften is licht rechtsscheef. De andere marginalen
### komen redelijk goed overeen met de normale verdeling.

#pairs(turnhout)

### Bivariate marginalen: een aantal variabelen vertoont een sterke correlatie
### en bij een aantal variabelen zijn er mogelijk uitschieters maar over het
### algemeen zien de bivariate verdelingen er redelijk normaal verdeeld uit.

#y = mahalanobis(turnhout, center=sapply(turnhout, mean), cov=cov(turnhout))^2
#dof=13
#qqplot(qchisq(ppoints(500), df= dof), y,
#              main = expression("Q-Q plot for" ~~ {chi^2}[nu == dof]))
#qqline(y, distribution = function(p) qchisq(p, df = dof),
#              prob = c(0.25, 0.75), col = 2)
#abline(h=qchisq(p=0.975, df=dof))
#mtext("qqline(*, dist = qchisq(., df=13), prob = c(0.1, 0.6))")

### Mahalanobis afstanden lijken redelijk normaal verdeeld. Wijken niet
### genoeg af om anormaliteit te veronderstellen.
### De horizontale by chi^2_0.025 ligt onder alle punten, niet zekere wat
### dat betekent.

#   2. Als de multivariate normaliteit niet aannemelijk zou blijken te zijn,
#      onderzoek dan of je de data kan aanpassen om beter aan deze
#      veronderstelling te voldoen.





# Opgave 3: Clustering
#   1. Voer een cluster analyse uit op de gegevens. Kies op basis van de
#      resultaten volgens verschillende clustermethodes een ``optimaal''
#      aantal clusters.



#   2. Stel de clusterresultaten grafisch voor en bespreek de kwaliteit van
#      de gevonden clustering. Bespreek gelijkenissen en/of verschillen tussen
#      de methoden.



#   3. Je kan ook een clustering uitvoeren vertrekkende van de scores van de
#      PCA analyse. Zou dit zinvol kunnen zijn of heeft een voorafgaande PCA
#      analyse weining zin? Levert dit een ander resultaat voor jullie
#      gegevens?





