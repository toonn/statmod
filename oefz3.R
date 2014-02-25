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
#X11()

# 2.a) Genereer verschillende keren n=20 gegevens uit een 4-variate normale
#      verdeling met gemmidelde mu=0_4 en Sigma=I_4. Maak een chi^2-plot van
#      de Mahalanobis afstanden en bekijk de variatie in de resultaten.

# 2.b) Vergelijk met de situatie n=100 en n=500

library(MASS)

mu = rep(0,4)
Sigma = diag(4)

attach(mtcars)
par(mfrow=c(3,4))
for(n in c(20,100,500)) {
    for (i in 1:4) {
        X = mvrnorm(n=n, mu=mu, Sigma=Sigma)
        dmah = mahalanobis(X, center=mu, cov=Sigma)
        qqplot(qchisq(ppoints(500),df=4), dmah,
               main=expression("Q-Q plot for" ~~ {chi^2}[nu == 4]))
        qqline(dmah, distribution = function(p) qchisq(p, df=4)
    }
}
