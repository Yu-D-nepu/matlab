What is this repository for?

matlab is used for a well-logging super-resolution method based on fractal interpolation optimized by Adaptive Mutation Particle Swarm Optimization

Usage

1、Choose one of the following options:
    1）For Windows 64-bit users, first run the matlab/hurst_exponent.m file via MATLAB to calculate the Hurst exponent of the well-logging curve.
    2）For Mac users with M-series chips, first run the matlab/hurst_exponent.m file via MATLAB 2022b or later to calculate the Hurst exponent of the well-logging curve.
2、After the first step is completed, run the matlab/AMPSO.m file to perform fractal interpolation with Adaptive Mutation Particle Swarm Optimization on the well-logging data.
3、After the second step is completed, run the matlab/bilstm.m file to use the regression model for predicting super-resolution results.
4、After the third step is completed, finally run the matlab/Spectrum_analysis.m file to plot the spectrum of the well-logging curve.

Who do I talk to?

Yu Deng.  Northeast Petroleum University
Email address:15765977066@163.com