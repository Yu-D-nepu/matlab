close all
clear

% Load the data

load('JIN31_Ori.mat')
data = readmatrix('JIN31_YPred.xlsx'); 
GR = data(2000:4000, 4);

GR_YPred = YPred';
GR_YPred = GR_YPred(1:2000);

figure(5)
% Fourier analysis
[S, F, Mag] = fft_analysis(GR, 1/0.125);
S(1) = 0;
plot(F, S, 'color', [0 0 1], 'linewidth', 1); 
hold on
[S, F, Mag] = fft_analysis(GR_YPred, 1/0.125);
S(1) = 0;
% Visualization
h = plot(F, S, 'color', [1 1 0], 'linewidth', 1.5); 
set(h, 'Color', [1 0 0 0.5]); 
xlim([0 2]);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
legend('Original', 'Our method');
