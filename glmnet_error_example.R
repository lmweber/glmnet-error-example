## Reproducible example to demonstrate possible bug in glmnet version 2.0-2
## Lukas M. Weber, June 2015

## This example generates an error when running glmnet version 2.0-2, but works fine 
## with version 1.9-8, which used a different implementation of cross validation (see 
## ChangeLog at http://cran.r-project.org/web/packages/glmnet/index.html).


# LOAD DATA
# Y: vector of response values
# X: design matrix of indicator variables and interaction terms
data <- read.table("data.txt", header=TRUE)
Y <- data[,1]
X <- as.matrix( data[,-1] )

# PENALTY FACTOR
# penalize interaction terms only
penalty <- rep(c(0,1), times=c(13,8))
penalty

# RUN GLMNET
# cv.glmnet: cross validation for lambda
library(glmnet)
set.seed(1)
cv.glmnet(x=X, y=Y, family="gaussian", penalty.factor=penalty)


# ERROR MESSAGE
# returns the following error message text:
# "Error in predmat[which, seq(nlami)] = preds : replacement has length zero"


# NOTES

# error doesn't occur when not using penalty.factor argument
cv.glmnet(x=X, y=Y, family="gaussian")

# error doesn't occur when using a pre-set lambda sequence
# (thanks to Charlotte Soneson for this part and comments below)
lambda <- exp(seq(log(0.001), log(5), length.out=15))
cv.glmnet(x=X, y=Y, family="gaussian", penalty.factor=penalty, lambda=lambda)

# error depends on random seed
set.seed(4)
cv.glmnet(x=X, y=Y, family="gaussian", penalty.factor=penalty)

# The problem may be occurring in this line:
# mlami = max(sapply(outlist, function(obj) min(obj$lambda)))
# in the function "cv.elnet()".
# If no lambda value is larger than mlami, the lambda value submitted to the predict 
# function will be "numeric(0)", and no predictions will be generated. This seems to 
# depend on the cross validation split, since sometimes it will work.



# SESSION INFORMATION
# tested on Linux and Mac systems
# see files "sessionInfo_Linux.txt" and "sessionInfo_Mac.txt"
sink("sessionInfo_Mac.txt")
sessionInfo()
sink()


