close all;
clc;
%%
% Load the data
% data_train = readmatrix('Training_set.xlsx');% Training set
% data_test = readmatrix('Testing_set.xlsx'); % Testing set 
data_train = readmatrix('Jin31.xlsx');% Training set
data_test = readmatrix('Gu204.xlsx'); % Testing set 
% Perform processing within a certain depth range
x = data_train(501:2501,1);     % For example, take the data within the depth range of 501 to 2501
y = data_train(501:2501,4);
x_test = data_test(2000:4000,1);  % Ensure the same length as the training set
y_test = data_test(2000:4000,4);

% Downsampling
Downsampling_multiple = 4; 
downsampling_data=Downsample(x,y,Downsampling_multiple);
downsampling_data_test=Downsample(x_test,y_test,Downsampling_multiple);
%%
% Fractal interpolation based on adaptive mutation particle swarm optimization

% Number of iterations
n=1;  
% Adaptive Mutation Particle Swarm Optimization algorithm
num_particles = 15; 
max_iterations = 10;
c1 = 1.45;
c2 = 1.45;

% Inertia weight varies with the number of iterations
w_values = plot_inertia_weight(max_iterations);

% Fractal interpolation
PQ = fractal2curves_with_PSO(downsampling_data,downsampling_data,1,Downsampling_multiple,num_particles,max_iterations,c1,c2);
PQ_test = fractal2curves_with_PSO(downsampling_data_test,downsampling_data_test,1,Downsampling_multiple,num_particles,max_iterations,c1,c2);

% Visualization
figure('Position', [100, 100, 800, 500])
plot(x_test,y_test); 
hold on
plot(PQ_test(1,:),PQ_test(2,:)); 
legend( 'Original','Fractal Interpolation with AMPSO');
xlabel('Depth (m)');
ylabel('GR(API)');
plot_inertia_weight(max_iterations);

%%
% Gaussian filter
O_data=[x';y'];
O_data_test=[x_test';y_test'];
g_filted = gfilter(PQ(2,:),O_data);
Outputline=[PQ(1,:);PQ(2,:)];
g_filted_test = gfilter1(PQ_test(2,:),O_data_test);
Outputline_test=[PQ_test(1,:);PQ_test(2,:)];

%Construct the dataset for training the BiLSTM network model
num=2; 
dataline_train =jubulinyu(O_data,Outputline,num);
dataline_test =jubulinyu(O_data_test,Outputline_test,num);

dataTrain =  [dataline_train y];
dataTest =  [dataline_test y_test];

function w_values = plot_inertia_weight(iterations)
    w_values = zeros(iterations, 1);
    for iter = 1:iterations
        w = 0.9 - (0.9 - 0.4) *(1 - exp(-15 * (iter/ 50).^4));
        w_values(iter) = w;
    end

    figure;
    plot(1:iterations, w_values, 'o-', 'Color', [0.2, 0.5, 0.8], 'MarkerFaceColor', [0.2, 0.8, 1], 'MarkerEdgeColor', [0.2, 0.7, 1], 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('Inertia Weight (w)');
    title('Variation of Inertia Weight with Iterations');
    grid on;
end