function g_filted=gfilter(g_value,O_data)

% Parameter settings
r = 80;
sigma = 25;
g_filted = Gaussianfilter(r, sigma, g_value);
xxx=linspace(0,length(g_filted),length(O_data(1,:)));

% Visualization
figure(3)
subplot(211)
plot(xxx,O_data(2,:))
hold on
plot(g_filted)
title('Gaussian filtering of the training set');
legend('Before filtering','After filtering','Location','northwest')
end