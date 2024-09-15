function [PQ] = fractal2curves_with_PSO(Original, Interpolation_point, n, Downsampling_multiple, num_particles, max_iterations,c1, c2)

    persistent Variation_factor_Original
    persistent Variation_factor
    col = length(Interpolation_point); 
    L = Interpolation_point(1,col) - Interpolation_point(1,1);
    a=zeros(col-1,1);  
    e=zeros(col-1,1); 
    c=zeros(col-1,1);
    f=zeros(col-1,1);
    particles = repmat(struct('position', zeros(col-1, 1), 'velocity', zeros(col-1, 1), 'personal_best', 0, 'personal_best_pos', zeros(col-1, 1), 'd_value', zeros(col-1, 1)), num_particles, 1);
     
    % Initialize the particles' positions and velocities
    for i = 1:num_particles
        particles(i).position = rand(col-1, 1)/5;                     
        particles(i).velocity = rand(col-1, 1)/5;  
        particles(i).personal_best_pos = particles(i).position;
        particles(i).personal_best = Inf;  
    end
    global_best_pos = particles(1).personal_best_pos;
    global_best = Inf;
    
    for iter = 1: max_iterations
        
        for i = 1:num_particles
            vfrand = rand();
            if isempty(Variation_factor_Original)
               Variation_factor_Original = 0;
               Variation_factor = 0;
            end
          
            if Variation_factor_Original==1
                
               if vfrand > 0.8
                  Variation_factor = 1;
               else
                  Variation_factor = 0;
               end              
            else
                Variation_factor_Original = 1;
            end          
                   
            if Variation_factor == 0
                
            % Update the particles' velocities and positions            
            w = 0.9 - (0.9 - 0.4) *(1 - exp(-15 * (iter/ max_iterations).^4));
            r1 = rand(size(particles(i).velocity)); 
            r2 = rand(size(particles(i).velocity)); 
            particles(i).velocity = w * particles(i).velocity + c1 * r1 .* (particles(i).personal_best_pos - particles(i).position) + c2 * r2 .* (global_best_pos - particles(i).position);
            particles(i).position = particles(i).position + particles(i).velocity;
            particles(i).position =min(abs(particles(i).position),1);
            d = particles(i).position;           
            end
            if Variation_factor == 1
               w = 0.9 - (0.9 - 0.4) *(1 - exp(-15 * (iter/ max_iterations).^4));
               particles(i).position = (2 * rand(col-1, 1)-1)/5;
               particles(i).velocity = (2 * rand(col-1, 1)-1)/5;     
               particles(i).personal_best_pos = particles(i).position;
               particles(i).position =min(abs(particles(i).position),1);
               d = particles(i).position;
            end
            
            for j = 1:col-1 
                a(j) = (Interpolation_point(1,j+1) - Interpolation_point(1,j)) / L;
                e(j) = (Interpolation_point(1,col) * Interpolation_point(1,j) - Interpolation_point(1,1) * Interpolation_point(1,j+1)) / L;
                c(j) = (Interpolation_point(2,j+1) - Interpolation_point(2,j) - d(j) * (Interpolation_point(2,col) - Interpolation_point(2,1))) / L;
                f(j) = (Interpolation_point(1,col) * Interpolation_point(2,j) - Interpolation_point(1,1) * Interpolation_point(2,j+1) - d(j) * (Interpolation_point(1,col) * Interpolation_point(2,1) - Interpolation_point(1,1) * Interpolation_point(2,col))) / L;
            end

            % Calculate fitness and update particle bests and global best
            PQ = [];
            for j = 1:col-1
                cov = [a(j) 0; c(j) d(j)];
                cons = [e(j); f(j)];
                for k = 1:col    
                    point = cov * [Interpolation_point(1,k); Interpolation_point(2,k)] + cons;
                    PQ = [PQ point];
                end

            end
             fitness = calculate_fitness(PQ,Original);            

            if fitness < particles(i).personal_best
                particles(i).personal_best = fitness;
                particles(i).personal_best_pos = particles(i).position;

            end
            fprintf('number of iterations: %d-%d - %d \n', i,iter,((iter-1)*num_particles+i));
            if fitness < global_best
                fprintf('result: %.12f\n',fitness);
                global_best = fitness;               
                global_best_pos = particles(i).position;
                
                g_str = mat2str(global_best_pos);
                d_str = mat2str(d);            
                D_d = d;
                disp(['d =', d_str]);
                A_a = a;
                C_c = c;
                E_e = e;
                F_f = f;
            end            
            fitness = [];
            PQ = [];

        end
    end   
    
    % Generate the final set of curves using the global best solution
    for i=1:n
        PQ = [];
        for j = 1:col-1
            cov = [A_a(j) 0; C_c(j) D_d(j)];
            cons = [E_e(j); F_f(j)];
            col2 = length(Interpolation_point);
            for k = 1:col2
                point = cov * [Interpolation_point(1,k); Interpolation_point(2,k)] + cons;
                PQ = [PQ point];
            end
        end
        Interpolation_point = PQ;
    end
end
function fitness = calculate_fitness(PQ, Original)

    % Calculate the spline interpolation curve
    xx = linspace(Original(1, 1), Original(1, end), size(PQ, 2));
    yy = spline(Original(1, :), Original(2, :), xx);
    
    % Calculate the root mean square error
    rmse = sqrt(mean((yy - PQ(2, :)).^2));   
    fitness = rmse;
end


