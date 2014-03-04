# Exercise 1
# 1. Read in R the file Dblood.dat. This data (from Jolliffe 2002) consist of
#    8 blood chemistry variables measured on 72 patients.

blood = read.table('Dblood.dat', header=TRUE)
print("Blood data:")
print(summary(blood))

# 2. Compute (and store) the corresponding covariance and correlation
#    matrices of this dataset.

S = cov(blood)
print("Covariance matrix:")
print(S)

R = cor(blood)
print("Correlation matrix:")
print(R)

# 3. Compute and compare the loading matrices obtained by applying PCA on (a)
#    the covariance matrix and (b) the correlation matrix. When looking at
#    the first loading vector, what is the main difference? what do you think
#    causes this?

pcaS = princomp(S)
print("PCA on S:")
print(loadings(pcaS))
print(summary(pcaS))

pcaR = princomp(R)
print("PCA on R:")
print(loadings(pcaR))
print(summary(pcaR))

par(mfrow=c(1,2))
screeplot(pcaS, type='lines')
screeplot(pcaR, type='lines')

### loading is spread over all components in PCA with correlation matrix
### this is to be expected because the normalization of the components takes
### away differences is scale

# 4. Now consider the PCA analysis that you think is the most appropriate for
#    this dataset. How many components would you choose to retain? Explain.

### PCA on correlation matrix
### Retaining 3 components gives a cumulative variance of ~90%, if we need to
### retain all the information we need 7 of 8 PC's



# Exercise 2: bivariate example
# 1. Load the Headsize data set (headsize.dat). The variables head1 and head2
#    are, respectively, the headsizes of 25 first sons-second sons pairs.

head = read.table('headsize.dat', header=TRUE)
print("Head size data of son and second son:")
print(summary(head))

# 2. Create a matrix composed of the variables head1 and head2.

head12 = head[,c('head1','head2')]

# 3. Would you rather perform a PCA analysis on the correlation or the
#    covariance matrix here? Explain.

### The covariance matrix because all measurements have the same scale.
### And we do not want to lose scatter information because of normalization.

# 4. From now on, consider the PCA analysis that you think is the most
#    appropriate for this dataset. Perform a PCA decomposition.

headS = cov(head12)
pcaHead = princomp(head12)

# 5. Compute the equation (intercept, slope) of the two principal components.

pcaComps = pcaHead$scores
reg <- lm(pcaComps[,2] ~ pcaComps[,1])

# 6. Plot the data, using the asp=1 option in the plot() command (this ensures
#    that the axes both have the same scales). Draw, using the abline()
#    command, the first two principal components.

plot(pcaComps, asp=1)
abline(reg)

# 7. On this plot, add the 97.5% tolerance ellipse.

#library(robustbase)
#tolEllipsePlot(pcaComps)

# 8. Compute the correlation between each of the principal components and the
#    original variables.

print(cor(pcaComps[,1], head12[,1]))
print(cor(pcaComps[,1], head12[,2]))
print(cor(pcaComps[,2], head12[,1]))
print(cor(pcaComps[,2], head12[,2]))



# Exercise 3: multivariate example

# 1. Load the heptathlon dataset. This is a dataset of measured performance
#    on the 7 components of olympic heptathlon for the 24 participants of the
#    1988 Seoul games (the last column is the finale score of the participants).
#    Create a data matrix X composed of the first seven columns of the
#    heptathlon dataset. We will be analysing X.



# 2. Would you rather perform a PCA analysis on the correlation or the
#    covariance matrix here? Explain.



# 3. How many principal component would you recover? Explain.



# 4. Interpret the first principal component.



# 5. Make a scatter plot of the scores. Interpret.



# 6. Make a plot of the first principal score versus the score variable from
#    the data set. Interpret.



# 7. Make a diagnostic plot with the Mahalanobis distances of the scores on the
#    horizontal axis and the orthogonal distances to the PCA subspace on the
#    vertical axis. Discuss the results.

