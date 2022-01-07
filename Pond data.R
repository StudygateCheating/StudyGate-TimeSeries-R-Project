

library(ggplot2)
library(data.table)
library(moments)
library(xts)
library(fpp2)
library(fpp)
library(ggfortify)

####Loading the dataset
pond=get(load("F:/pond.RData"))
View(pond)


## Characteristics of a time series
start(pond)      # start date
end(pond)        # end date
frequency(pond)  # number of observations per "main time unit" (ie year)

#Time series plot
par(mfrow=c(1,1))
autoplot(pond) + # ggtitle("Monthly pond water levels in feet") + geom_line(na.rm=TRUE) + 
  xlab("Month") + ylab("Monthly pond water levels in feet") +
  stat_smooth(colour = "green")+labs(title = "Monthly pond water levels in feet since jan 1966",
                                     x = "Date",
                                     y = "Monthly pond water levels in feet")



#Converting to ts object
pond_ts <- ts(pond, frequency = 12, start = c(1966, 1))
pond_ts


#Time series decomposition
pond_ts_decomposed_additive <- decompose(pond_ts)

plot(pond_ts_decomposed_additive)



####
pond %>% decompose(type="multiplicative") %>%
  autoplot() + xlab("Year") +
  ggtitle("Monthly pond level multiplicative decomposition")


####
pond %>% decompose(type="additive") %>%
  autoplot() + xlab("Year") +
  ggtitle("Monthly pond level additive decomposition")


###################
################################################

## Fit a linear trend
pond.tt = 1:length(pond) # don't use "t" as it is a function in R!
fit1 = lm(pond~pond.tt);summary(fit1)

trend1 = fitted(fit1) # trend as a vector; convert it to a "ts" object
trend1 = ts(trend1, start=start(pond), end=end(pond), frequency=frequency(pond))

## Superimpose on time series plot
lines(trend1, col="blue")

################################################

## Find and plot residuals
resid1 = ts(residuals(fit1), start=start(pond), end=end(pond), 
            frequency=frequency(pond))

autoplot(resid1, ylab="Residuals",main="Plot of residuals")

#####################################################

## Observe (1) some trend remaining (2) cyclic pattern (3) increasing
## variance.


## Consider using a non-linear trend (in this case, quadratic).
pond.tt2 = pond.tt^2
fit2 = lm(pond ~ pond.tt + pond.tt2);summary(fit2)
trend2 = fitted(fit2)
trend2 = ts(trend2, start=start(pond), end=end(pond), frequency=frequency(pond))

resid2 = ts(residuals(fit2), start=start(pond), end=end(pond), 
            frequency=frequency(pond))
autoplot(resid2,main="Plot of sqaured residuals")
#lines(trend2, col="blue")


###############################################

## Finally, fit seasonal effect

## Create dummy variables for each month
n = length(pond)
jan = as.numeric((1:n %% 12) == 1)
feb = as.numeric((1:n %% 12) == 2)
mar = as.numeric((1:n %% 12) == 3)
apr = as.numeric((1:n %% 12) == 4)
may = as.numeric((1:n %% 12) == 5)
jun = as.numeric((1:n %% 12) == 6)
jul = as.numeric((1:n %% 12) == 7)
aug = as.numeric((1:n %% 12) == 8)
sep = as.numeric((1:n %% 12) == 9)
oct = as.numeric((1:n %% 12) == 10)
nov = as.numeric((1:n %% 12) == 11)
dec = as.numeric((1:n %% 12) == 0)

## Fit model to our residuals using the dummy variables
fit4 = lm(resid3 ~ 0 + jan + feb + mar + apr + may + jun + jul + aug +
            sep + aug + oct + nov + dec)
summary(fit4)

## So, for example, log sales are typically 0.08 below the trend in January;
## 0.02 above the trend in March etc.

## Now see what variation is left after removal of trend and seasonal effects.
seasonal = ts(fitted(fit4), start=start(pond), end=end(pond),
              frequency=frequency(pond))
fv = trend3 + seasonal
resid5 = log.pond - fv
par(mfrow=c(1,1))
plot(log.pond, ylab="log pond water level(feet)",main="Plot after removal of trend
     and seasonal component")
lines(fv, col="blue")

############################################

plot(resid5, ylab="Residuals",main="Plot of residuals after removal of trend
     and seasonal component")

## No clearly visible structure remaining.  However, plotting the
## residual at time t+1 against the residual at time t shows that
## successive fluctuations are not independent.

par(mfrow=c(1,1))
plot(resid5[-1]~resid5[-n], xlab=expression(Y[t]),
     ylab=expression(Y[t+1]), pch=16)

################################################

## If we look at observations five time-points apart, this correlation
## has vanished:
plot(resid5[-(1:5)]~resid5[-((n-4):n)], xlab=expression(Y[t]),
     ylab=expression(Y[t+5]), pch=16)

###############################################

## But at 20 time points, it is back:
plot(resid5[-(1:20)]~resid5[-((n-19):n)], xlab=expression(Y[t]),
     ylab=expression(Y[t+20]), pch=16)

##################################################
## Generate simulated examples of MA(q) processes
set.seed(1342)

####AUtocorrelation and partial autocorrelation functions
par(mfrow=c(2,1))
acf(pond)
pacf(pond)
auto.arima(pond)

#Fitting the MA Model to the time series
MA1 <- arima(pond, order = c(0,0,1))
print(MA1)

MA2 <- arima(pond, order = c(0,0,2))
print(MA2)
MA3 <- arima(pond, order = c(0,0,3))
print(MA3)
MA4 <- arima(pond, order = c(0,0,4))
print(MA4)


## Now play with (i) repeated realisation to see the natural variation
## in MA data (ii) experimenting with different values of n (iii)
## experimenting with different values of q and beta.

##########################Fitting an AR(P) model
#Fitting the AR Model to the time series
AR1 <- arima(pond, order = c(1,0,0))
print(AR1)

AR2 <- arima(pond, order = c(2,0,0))
print(AR2)
AR3 <- arima(pond, order = c(3,0,0))
print(AR3)
AR4 <- arima(pond, order = c(4,0,0))
print(AR4)

par(mfrow=c(1,1))
#plotting the series along with the fitted values
ts.plot(pond)
AR_fit <- pond - residuals(AR)
points(AR_fit, type = "l", col = 2, lty = 2)
autoplot(AR_fit)+points(AR_fit, type = "l", col = 2, lty = 2)



#############################################################################################
######Estimation of  AR coefficients using Yule-Walker



## The function 'acf2AR' computes AR(p) coefficients given the first p

acf2AR(acf=c(1, 1/6, -11/24))

## Imagine having data generated by this process; we can simulate some
## using 'arima.sim'.
set.seed(123484)
X = arima.sim(n=1000, model=list(ar=c(0.25, -0.5)))

## We can use 'acf' to compute the first 5 sample autocorrelations.
acf(X, plot=F, lag=5)

## Now fit an AR(2) process
acf2AR(acf=c(1.000,  0.169, -0.459))
## Compare these fitted AR(2) parameters to the true alpha_1 = 0.25,
## alpha_2 = -0.5.

## soliving the yule walker equation using R function 'ar'
ar1=ar(pond, order=1, aic=F);ar1
ar2=ar(pond, order=2, aic=F);ar2
ar3=ar(pond, order=3, aic=F);ar3
require(forecast)
library(stats)





#######################################
pond_data = 1:length(pond) 
pond_data2 = pond_data^2
log.pond = log(pond)
fit3 = lm(log.pond ~ pond_data + pond_data2)
trend3 = ts(fitted(fit3), start=start(pond), frequency=frequency(pond))
resid3 = ts(residuals(fit3), start=start(pond), frequency=frequency(pond))
n = length(pond)
jan = as.numeric((1:n %% 12) == 1)
feb = as.numeric((1:n %% 12) == 2)
mar = as.numeric((1:n %% 12) == 3)
apr = as.numeric((1:n %% 12) == 4)
may = as.numeric((1:n %% 12) == 5)
jun = as.numeric((1:n %% 12) == 6)
jul = as.numeric((1:n %% 12) == 7)
aug = as.numeric((1:n %% 12) == 8)
sep = as.numeric((1:n %% 12) == 9)
oct = as.numeric((1:n %% 12) == 10)
nov = as.numeric((1:n %% 12) == 11)
dec = as.numeric((1:n %% 12) == 0)
fit4 = lm(resid3 ~ 0 + jan + feb + mar + apr + may + jun + jul + aug +
            sep + aug + oct + nov + dec)
seasonal = ts(fitted(fit4), start=start(pond), end=end(pond),
              frequency=frequency(pond))
fv = trend3 + seasonal
resid5 = log.pond - fv


## Plot data, detrended, and deseasonalised along with correlograms.
par(mfrow=c(4,2), mar=c(4,4,1,1)+0.1)
plot(pond, ylab="Data"); acf(pond, main="")
plot(resid3, ylab="Detrended"); acf(resid3, main="")
plot(resid5, ylab="Deseasonalised"); acf(resid5, main="")

## Now fit AR(1) and plot residuals
#acf(resid5, plot=F, lag=1) # alpha hat = rho hat 1 = 0.671

## Fit AR(1) and store results
arfit = ar(resid5, order=1, aic=F) 
arfit # Print fit summary; confirms alpha hat = 0.671
ar(resid5, order=2, aic=F) 

## Examine structure of the stored results of fitting AR(1).
str(arfit)

## Plotting the correlogram:
plot(arfit$resid, ylab="AR residuals")
acf(arfit$resid, na.action=na.omit, main="")
## 

par(mfrow=c(1,1))
