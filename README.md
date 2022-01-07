# StudyGate-TimeSeries-R-Project
Time series modeling with monthly pond water level observations 
Summary 
The study applied time series analysis techniques in investigating the features that are associated with the monthly pond water level in feet from the year 1966 to 2015. The series present remarkable variations, upward and downward movements across the time period. The series did show evidence of a remarkable upward or downward linear trend, but the mean component, shown by the intercept of 2.52 was quite significant.  The absence of linear trend or second order trend as well as the cyclical variations may imply that the water level in the pond is to some extend a function of random fluctuation and some season related changes.  After removal of the seasonal and trend components, the residuals show lagged correlations, such that future observations may be predicted based on previous observations.   The modelling procedure was done both recursively, trying different combination of number of time lags that would present the best model for predicting monthly pond water level. The emerging model from the model estimation process implies that future observations influenced by both the present and past observations.   Future observations for the pond water level at time t, may be obtained by taking a constant of 2.52 feet and adding to the previous measurements at time t-1, t-2, t-3 multiplies by factors of 0.7896, -0.079, and 0.0169 respectively.  
 
 
Introduction 
The analysis presents an investigation of the various of the time series data related to the pond water level measures every first day of the months in feet from 1966 to 2015. The data is analyzed for key time series components such as the trend, cyclical component, seasonal component and the irregular fluctuations. The initial stages of fitting time series models require that the observation are separated for the features such as seasonality, trend and cyclical components so as to derive models with parameters have remarkable stability of forecasts.  The dataset contains a total of 600 monthly observations on the depth of pond water measured in feet on the first day of every monthly since January 1966.  
 
 
 
 
 
 
 
 
 
Time series plot of the monthly post water levels in feet 
 
The time series plot of the pond depth observations present some features that are typical to time series observations such as a pattern of upward and downward fluctuation which is observations through the entire length of the data. It is not apparent for the plot if the fluctuations are exhibit seasonality or cyclical variations. Cyclical variations are periodic upward or downward movements in a time series with a cycle period longer than a year. Prosperity, recession, depression, and recovery are the four phases of a business cycle that shows these cyclical oscillations. The trend component is not very conspicuous in the observations, further analysis may be required to isolate the presence of additional features like trend and the random processes. The seasonally adjusted series can be beneficial if the volatility due to seasonality is not of major relevance. Monthly unemployment figures, for example, are frequently seasonally adjusted to emphasize variance attributable to the underlying status of the economy rather than seasonal variation. 
Decomposition of the time series into individual components 
 
A breakdown of the monthly pond water height readings into its constituent components using additive decomposition reveals the following; There were no obvious indications of the trend component while there are elaborate cycles that point to the presents of the seasonal component. There are pronounced irregular fluctuations that may add to the noise process in the lower part of the decomposed series.  
Fitting the linear trend regression model 
The first order linear trend model was fitted to the monthly pond water level data to investigate the present of the trend component using the ordinary least squares technique. The pond water level reading was regressed against time of the observations. The intercept term of the model was 2.5 feet. The trend coefficient of 0.000066, there is not strong evidence for trend term being present in the model, the pond water level measurements do not exhibit a particular trend, say upward or downward.   The results show that the pond water level readings are not an increasing function of time. The plot of squared residuals still does not present evidence of trend component, there no indications of increasing variance although this time the first order and the second order trend terms are significant from the statistical tests.  The model fitting procedure is repeated to address the possibility of their being significant higher order term like the quadratic of cubic trend term which may explain the pond water level observations. 
Checking to non-constant variance 
The assumption of constant variance is a pre-requisite assumption for almost any modeling procedure, this is important in ensuring that the standard errors of the model are not inflated and that the parameters and confidence interval obtained are stable.  The analysis further investigates the presence of key seasonal effects that may be associated with the months.  The significance of parameters tests indicated that non-of the months had a significant effect on the pond water level.  If there are some patterns of fluctuations, then they could not be seasonal but rather cyclical where they are observable after a fairly long period of time, say 4 years.  
What variation is left after removal of trend and seasonal effects? 
A plot of the residuals at time t+1 against the residual at present time (t) shows that successive fluctuations are not independent.  Previous observations could greatly influence the next time period observations. The same approach can be taken five steps back where observations five time-points apart are observed and the correlation noted. 
 
Observations five-time points apart do not show profound correlations; the pattern has now become extremely random.  The results show that the monthly pond water level in the pond may be correlated to the values of one month back but the correlation does not seem to go beyond one time-period in the past.  
Moving average model 
 
Fitting the AR(P) using the Yule walker equations 
The AR(p) for p=1,2,3 was fitted using R function ar, which solves the Yule walker equation. 
Yt = b0 + b1Yt–1 + ut 
The AR (1) model is obtained as follows: 
Yt = 2.5169 + 0.7356Yt–1 + ut 
 
AR (2) 
Yt = 2.5160 + 0.7885Yt–1 - 0.0666Yt–2 + ut 
 
AR (3) 
 
Yt = 2.5160 + 0.7896Yt–1 -0.0799Yt–2 + 0.0169Yt–3 + ut 
 
The lagged changes in the pond water levels are significant predictors of the next time period water level in feet.  
Plotting detrended, and deseasonalised data along with correlograms 
 
 The correlograms are consistent with the white noise process, which therefore calls for no further modeling.  The Acf function for the detrended series is very similar to the Acf for the original data except the fact that the spikes are higher in the original dataset.  The AR residuals appear to occur in a very random pattern.  
Conclusion 
The study applied time series analysis techniques in investigating the features that are associated with the monthly pond water level in feet since 1966. While the series presented remarkable variations, there was no visible terns component in the data. After removal of the seasonal and linear trend components, the residuals showed lagged correlations, such that future observations may be predicted based on previous observations.   The modelling procedure was done both recursively and with the use of the Auto.arima R function that finds the best parameters that fits the time series observations.   The results pointed that future observations influenced by both the present and past observations.  Future observations for the pond water level at time t, may be obtained by taking a constant of 2.52 feet and adding to the previous measurements at time t-1, t-2, t-3 multiplies by factors of 0.7896, -0.079, and 0.0169 respectively.  
 
