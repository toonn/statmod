newplotwindow <- function () {
    X11()
    #window()
}
# 1.a) Genereer verschillende keren n=20 gegevens uit een normale verdeling
#      met gemiddelde mu=2 en standaarddeviatie sigma=3.
#      Maak een normale QQ-plot en bekijk de variatie in de resultaten.

# 1.b) Vergelijk met de situatie n=100 en n=500.

#mu = 2
#sigma = 3
#
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

#library(MASS)
#
#mu = rep(0,4)
#Sigma = diag(4)
#
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

#ces = read.csv(file="ces.csv")
#fdhofdaw = ces[ces$'FDHO' > 0 & ces$'FDAW' > 0, c('FDHO','FDAW')]
#
#par(mfrow=c(1,2))
#qqnorm(fdhofdaw$FDHO)
#qqline(fdhofdaw$FDHO)
#print(shapiro.test(fdhofdaw$FDHO))
#qqnorm(fdhofdaw$FDAW)
#qqline(fdhofdaw$FDAW)
#print(shapiro.test(fdhofdaw$FDAW))
#newplotwindow()
#
#library(car)
##powerTransform(fdhofdaw$FDHO) used to determine value for lambda on next line
#boxcoxFDHO = bcPower(fdhofdaw$FDHO, lambda=0.2472)
##powerTransform(fdhofdaw$FDAW) used to determine value for lambda on next line
#boxcoxFDAW = bcPower(fdhofdaw$FDAW, lambda=0.2083)
#
#par(mfrow=c(1,2))
#qqnorm(boxcoxFDHO)
#qqline(boxcoxFDHO)
#print(shapiro.test(boxcoxFDHO))
#qqnorm(boxcoxFDAW)
#qqline(boxcoxFDAW)
#print(shapiro.test(boxcoxFDAW))
#newplotwindow()
#
#panel.bxp <- function(x, ...)
#{
#        usr <- par("usr"); on.exit(par(usr))
#    par(usr = c(0, 2, usr[3:4]))
#        boxplot(x, add=TRUE)
#}
#
#pairs(fdhofdaw, diag.panel = panel.bxp, text.panel = function(...){})
#newplotwindow()
#
#boxcoxFDHOFDAW = bcPower(fdhofdaw, lambda=powerTransform(fdhofdaw)$lambda)
#pairs(boxcoxFDHOFDAW, diag.panel = panel.bxp, text.panel = function(...){})
#
#library(mvnormtest)
#mshapiro.test(fdhofdaw)
#mshapiro.test(boxcoxFDHOFDAW)

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

#library(robustbase)
#
#tolEllipseplot(boxcoxFDHOFDAW)

#mu1T = mean(boxcoxFDHOFDAW$FDHO)
#sd1T = sd(boxcoxFDHOFDAW$FDHO)
#n = nrow(boxcoxFDHOFDAW)
#CI1l = mu1T - qnorm(0.975)*sd1T/sqrt(n)
#CI1u = mu1T + qnorm(0.975)*sd1T/sqrt(n)
#print("univariate confidence intervals mu1, mu2:")
#print(paste("l: ", CI1l, " - u: ", CI1u))
#mu2T = mean(boxcoxFDHOFDAW$FDAW)
#sd2T = sd(boxcoxFDHOFDAW$FDAW)
#CI2l = mu2T - qnorm(0.975)*sd2T/sqrt(n)
#CI2u = mu2T + qnorm(0.975)*sd2T/sqrt(n)
#print(paste("l: ", CI2l, " - u: ", CI2u))
#
#SCI1l= mu1T-qt(0.975,df=n-1)*sd1T/sqrt(n)
#SCI1u= mu1T+qt(0.975,df=n-1)*sd1T/sqrt(n)
#SCI2l= mu2T-qt(0.975,df=n-1)*sd2T/sqrt(n)
#SCI2u= mu2T+qt(0.975,df=n-1)*sd2T/sqrt(n)
#print("univariate simultaneous confidence intervals mu1, mu2:")
#print(paste("l: ", SCI1l, " - u: ", SCI1u))
#print(paste("l: ", SCI2l, " - u: ", SCI2u))
#
#alpha = 0.025/4
#BCI1l = mu1T-qt(1-alpha,df=n-1)*sd1T/sqrt(n)
#BCI1u = mu1T+qt(1-alpha,df=n-1)*sd1T/sqrt(n)
#BCI2l = mu2T-qt(1-alpha,df=n-1)*sd2T/sqrt(n)
#BCI2u = mu2T+qt(1-alpha,df=n-1)*sd2T/sqrt(n)
#print("univariate bonferroni confidence intervals mu1, mu2:")
#print(paste("l: ", BCI1l, " - u: ", BCI1u))
#print(paste("l: ", BCI2l, " - u: ", BCI2u))
#print(t.test(boxcoxFDHOFDAW[,1],conf.level=(1-0.025/2))$conf.int)
#
#print("lengte BCI/SCI:")
#print(paste("mu1: ", (BCI1u-BCI1l)/(SCI1u-SCI1l)))
#print(paste("mu2: ", (BCI2u-BCI2l)/(SCI2u-SCI2l)))
