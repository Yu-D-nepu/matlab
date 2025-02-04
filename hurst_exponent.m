% The Hurst exponent
% Load the data
load('Gu.mat')
data=table2array(Gu43(505:2505,4))';
hurst = estimate_hurst_exponent(data);
[s, err] = sprintf('Hurst exponent = %.4f', hurst); disp(s);

function [hurst] = estimate_hurst_exponent(data0)   % data set

data = data0; % make a local copy

[M, npoints] = size(data0);

yvals = zeros(1, npoints);
xvals = zeros(1, npoints);
data2 = zeros(1, npoints);

index = 0;
binsize = 1;

while npoints > 4

    y = std(data);
    index = index + 1;
    xvals(index) = binsize;
    yvals(index) = binsize * y;

    npoints = fix(npoints / 2);
    binsize = binsize * 2;
    for ipoints = 1:npoints % average adjacent points in pairs
        data2(ipoints) = (data(2 * ipoints) + data((2 * ipoints) - 1)) * 0.5;
    end
    data = data2(1:npoints);

end % while

xvals = xvals(1:index);
yvals = yvals(1:index);

logx = log(xvals);
logy = log(yvals);

p2 = polyfit(logx, logy, 1);
hurst = p2(1); % Hurst exponent is the slope of the linear fit of log-log plot

% Plotting the log-log plot and the fitted line
figure;
plot(logx, logy, 'bo-'); % log-log plot
hold on;
plot(logx, polyval(p2, logx), 'r-');
xlabel('log(Bin Size)');
ylabel('log(Bin Size * Std Dev)');
title('Log-Log Plot for Hurst Exponent Estimation');
legend('Data', 'Fitted Line');
grid on;
hold off;
end
