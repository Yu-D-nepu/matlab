function [S, F, Mag] = fft_analysis(signal, fs)
    % Perform FFT on the input signal to obtain the spectrum information
    N = length(signal);
    Y = fft(signal, N);
    P2 = abs(Y/N);
    S = P2(1:N/2+1);
    S(2:end-1) = 2*S(2:end-1);
    F = fs*(0:(N/2))/N;
    Mag = 20*log10(S);
end