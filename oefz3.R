newplotwindow <- function () {
    X11()
    #window()
}
# 1.a) Genereer verschillende keren n=20 gegevens uit een normale verdeling
#      met gemiddelde mu=2 en standaarddeviatie sigma=3.
#      Maak een normale QQ-plot en bekijk de variatie in de resultaten.

# 1.b) Vergelijk met de situatie n=100 en n=500.

mu = 2
sigma = 3

#attach(mtcars)
#par(mfrow=c(3,4))
#for(n in c(20,100,500)) {
#    for (i in 1:4) {
#        X = rnorm(n=n, mean=mu, sd=sigma)
#        qqnorm(X)
#        qqline(X)
#    }
#}
#newplotwindow()

# 2.a) Genereer verschillende keren n=20 gegevens uit een 4-variate normale
#      verdeling met gemmidelde mu=0_4 en Sigma=I_4. Maak een chi^2-plot van
#      de Mahalanobis afstanden en bekijk de variatie in de resultaten.

# 2.b) Vergelijk met de situatie n=100 en n=500

library(MASS)

mu = rep(0,4)
Sigma = diag(4)

#attach(mtcars)
#par(mfrow=c(3,4))
#for(n in c(20,100,500)) {
#    for (i in 1:4) {
#        X = mvrnorm(n=n, mu=mu, Sigma=Sigma)
#        dmah = mahalanobis(X, center=mu, cov=Sigma)
#        qqplot(qchisq(ppoints(500),df=4), dmah,
#               main=expression("Q-Q plot for" ~~ {chi^2}[nu == 4]))
#        qqline(dmah, distribution = function(p) qchisq(p, df=4))
#    }
#}
#
#newplotwindow()

# 3.a) Lees de ces.csv dataset in.
# 3.b) Plaats in matrix FDHOFDAW de waarden van de variabelen FDHO en FDAW
#      voor alle datapunten waarvoor beide observaties strikt groter zijn dan 0.
# 3.c) Voor elke van de variabelen in FDHOFDAW:
#         I. Onderzoek de normaliteit van de oorspronkelijke variabelen.
#        II. Bepaal de optimaal Box-Cox transformatie.
#       III. Onderzoek de normaliteit van de getransformeerde variabelen.
# 3.d) Gezamenlijk voor beide variabelen in FDHOFDAW:
#         I. Onderzoek de bivariate normaliteit van de oorspronkelijke
#            variabelen.
#        II. Bepaal de optimaal *multivariate* Box-Cox transformatie.
#       III. Onderzoek de bivariate normaliteit van de getransformeerde
#            variabelen.



# 4.a) Bepaal
#         I. De 97.5 percent betrouwbaarheidsellips voor mu_.T
#            (de gemiddelde volgens de kolommen van de getransformeerde
#             variabelen).
#        II. De 97.5 percent univariate betrouwbaarheidsintervallen van
#            mu_1T en mu_2T
#       III. De 97.5 percent simultane univariate betrouwbaarheidsintervallen
#            van mu_1T en mu_2T
#        IV. De Bonferroni betrouwbaarheidsintervallen met een gezamenlijk
#            betrouwbaarheid van minstens 97.5 percent.
# 4.b) Vergelijk de lengte van de Bonferroni intervallen met de lengte van
#      de simultane intervallen.
# 4.c) Test (op de 5 percent) of mu_0 = (27.75, 14.55) a.d.h.v. de voorgaande
#      intervallen. Leveren zij steeds hetzelfde resultaat?
# 4.d) Maak 1 figuur met de ellips, de intervallen en mu_0.
