# Oefenzitting 2

# 1. Genereer random n = 100 gegevens uit een bivariate normale verdeling met
#    gemiddelde μ = (2,3)t, en varianties s11 = 5 en s22 = 2. Varieer de
#    covariantie s12 zodanig dat de correlatie tussen X1 en X2 achtereen-
#    volgens 0, 0.3, 0.6 en 0.9 is. Maak een scatterplot van elke situatie.

library(MASS)

sigma = function(correlatie) {
    s12 = sqrt(5)*sqrt(2)*correlatie
    return(matrix(c(5,s12,s12,2),ncol=2))
}

for(corr in c(0,0.3,0.6,0.9)){
    mvrnorm(100, mu=c(2,3), Sigma=sigma(corr))
}

data = mvrnorm(100, mu=c(2,3), Sigma=sigma(0.6))

# Gebruik vanaf nu steeds de data set met r12 = 0.6.

# 2. Toon aan (in R) dat deze correlatie overeenkomt met de covariantie
#    tussen de gestandaardiseerde gegevens.

standard = scale(data)
covar = cov(standard[,1], standard[,2])
print("Correlatie van de steekproef komt overeen met de correlatie in de populatie: 0.6")
print(paste("0.6 = ~",covar))

# 3. Illustreer dat het gemiddeldeende (empirische) covariantiematrix affien
#    equivariant zijn.

A = matrix(rexp(14, rate=.1),ncol=2,nrow=7)
d = rexp(7,rate=.1)

Xbar = apply(data, 2, FUN=mean)
Sx = cov(data)

Y = t(A%*%t(data) + d)
Ybar = A %*% Xbar + d
Sy = A %*% Sx %*% t(A)

print("Affiene equivariantie")
print("A*Xbar+d:")
#print(Ybar)
print("Ybar:")
#print(apply(Y,2,mean))
print(Ybar == apply(Y,2,mean))
print("A*Sx*At:")
#print(Sy)
print("Sy:")
#print(cov(Y))
print(Sy == cov(Y))

# 4. Illustreer dat de Mahalanobis afstanden affien invariant zijn.

print("Affiene equivariantie van mahalanobis afstanden")
#print(mahalanobis(data, center=Xbar, cov=Sx) == mahalanobis(Y, center=Ybar, cov=Sy))
print("    Error: singular...")

# 5. Gegeven een (n × p) data matrix X met covariantiematrix S, kunnen
#    we de gesfeerde data XS^−1/2 beschouwen.

# (a) Toon aan (door uitwerking) dat de Mahalanobis afstand tussen twee
#     observaties gelijk is aan de Euclidische afstand tussen de
#     overeenkomstige gesfeerde observaties.

###dE(x,y) = sqrt(((x-y)S^-1/2)t ((x-y)S^-1/2))
###        = sqrt(S^-1/2 (x-y)t (x-y) S^-1/2)
###        = ?

# (b) Beschouw opnieuw de bivariate data set. Maak een scatterplot van de
#     oorspronkelijke gegevens, de gestandaardiseerde gegevens en de
#     gesfeerde gegevens. Op de eerste figuur voeg je de
#     ‘tolerance ellipse’ toe:
#       {x; (x − μ)tΣ−1(x − μ) = c^2} met c = sqrt(χ^2_p,α).
#     Op de eerste figuur voeg je ook de tolerance ellips
#     toe, gebaseerd op de schattingen voor μ en Σ:
#       {x; (x − xbar)tS−1(x − xbar) = c^2}
#     Op de laatste figuur voeg je overeenkomstige ‘tolerance sphere’ toe.

library(robustbase)
tolEllipsePlot(data)
library(ellipse)
ellipse(Sx,centre=Xbar)
plot(data)
