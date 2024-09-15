%% Load the data

[mm,nn]=size(dataTrain);
[mmm,nnn]=size(dataTest);

% Data preprocessing
mu = mean(dataTrain);
sig = std(dataTrain);
for i=1:nn
    dataTrainStandardized(:,i) = (dataTrain(:,i) - mu(i)) / sig(i);
end
XTrain = dataTrainStandardized(:,1:nn-1)';
YTrain = dataTrainStandardized(:,nn)';
mu1 = mean(dataTest);
sig1 = std(dataTest); 
for k=1:nnn-1
    dataTestStandardized(:,k) = (dataTest(:,k) - mu1(k)) / sig1(k);
end
XTest = dataTestStandardized(:,1:nnn-1)';
YTest = dataTest(:,nnn)';

%%
%Create a BiLSTM regression network
numFeatures = size(XTrain, 1);
numHiddenUnits = 200;
layers = [ ...
    sequenceInputLayer(numFeatures)
    bilstmLayer(numHiddenUnits, 'OutputMode', 'sequence')
    dropoutLayer(0.2)
    fullyConnectedLayer(1)
    regressionLayer];

% Define the training parameters and optimizer
maxEpochs = 60;
miniBatchSize = 128;
initialLearnRate = 0.001;
learnRateDropPeriod = 210;
learnRateDropFactor = 0.9;
gradientThreshold = 1;
options = trainingOptions('adam', ...
    'MaxEpochs', maxEpochs, ...
    'MiniBatchSize', miniBatchSize, ...
    'InitialLearnRate', initialLearnRate, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropPeriod', learnRateDropPeriod, ...
    'LearnRateDropFactor', learnRateDropFactor, ...
    'GradientThreshold', gradientThreshold, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', {XTest, YTest}, ...
    'ValidationFrequency', 10, ...
    'Verbose', false, ...
    'Plots', 'training-progress');
net = trainNetwork(XTrain,YTrain,layers,options);

%Prediction
net = resetState(net);
YPred = predict(net, XTest, 'MiniBatchSize', miniBatchSize);
%De-normalization
YPred = sig1(nnn)*YPred + mu1(nnn);  

%%
%Calculate the evaluation metrics
rmse = sqrt(mean((YPred(1:801) - YTest(1:801)).^2));   
MAPE = mean(abs((YTest - YPred)./YPred))*100;  
MAE = mean(abs(YTest - YPred));  
PCC=corr(YTest',YPred');
mse = mean((YTest' - YPred').^2);
psnr = 20*log10(max(YTest)/sqrt(mse));
SSres = sum((YTest - YPred).^2);
mean_y_true = mean(YTest);
SStot = sum((YTest - mean_y_true).^2);
r2 = 1 - SSres/SStot;

disp(['PCC: ', num2str(PCC)]);
disp(['MSE: ', num2str(mse)]);
disp(['PSNR: ', num2str(psnr)]);
disp(['MAE: ', num2str(MAE)]);
disp(['RMSE: ', num2str(rmse)]);
disp(['R^2: ', num2str(r2)]);
%%
% Visualization
figure(4)
plot(x_test , YTest,'LineWidth', 1.2) 
hold on
plot(x_test , YPred,'LineWidth', 1.2) 
hold off
legend(["Original" ,"Predicted"])
xlabel("Depth(m)")
ylabel("GR(API)")
title("Fractal Interpolation with PSO Results")

