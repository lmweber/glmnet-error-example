## Reproducible example to demonstrate possible bug in glmnet version 2.0-2
## Lukas M. Weber, 2015-06-19

## This example generates an error when running glmnet version 2.0-2, but works fine 
## with version 1.9-8, which used a different implementation of cross validation (see 
## ChangeLog at http://cran.r-project.org/web/packages/glmnet/index.html).

## The error seems to occur when using the "penalty.factor" argument to shrink only some 
## variables in a model with design matrix consisting of indicator variables only.

## Error message text:
## "Error in predmat[which, seq(nlami)] = preds : replacement has length zero"


# LOAD DATA
# Y is vector of response values, X is design matrix of indicator variables only
data <- read.table("data.txt", header=TRUE)
Y <- data[,1]
X <- as.matrix( data[,-1] )

# PENALTY FACTOR
# penalize interaction columns only
penalty <- rep(c(0,1), times=c(13,8))
penalty

# RUN GLMNET
# cv.glmnet: cross validation for lambda
library("glmnet")
set.seed(1)
cv.glmnet(x=X, y=Y, family="gaussian", penalty.factor=penalty)

# returns the following error message text:
# "Error in predmat[which, seq(nlami)] = preds : replacement has length zero"

# note error doesn't occur when not using "penalty.factor" argument
cv.glmnet(x=X, y=Y, family="gaussian")


# SESSION INFORMATION
# tested on Linux and Mac systems
# see files "sessionInfo_Linux.txt" and "sessionInfo_Mac.txt"
sink("sessionInfo.txt")
sessionInfo()
sink()

