clc;
clear;
close all;

%% ==============================
% DOMAIN PARAMETERS
%% ==============================

Lx = 0.1;
Ly = 0.1;

nx = 40;
ny = 40;

dx = Lx/(nx-1);
dy = Ly/(ny-1);

x = linspace(0,Lx,nx);
y = linspace(0,Ly,ny);

[X,Y] = meshgrid(x,y);

%% ==============================
% TIME PARAMETERS
%% ==============================

dt = 0.01;
nt = 150;

%% ==============================
% MATERIAL PROPERTY
%% ==============================

alpha = 1e-4;

r = alpha*dt/(dx^2);

if r > 0.25
    error('Reduce dt. Stability condition violated')
end

%% ==============================
% HEAT SOURCE PARAMETERS
%% ==============================

Q0 = 800;
v = 0.02;
sigma = 0.01;

%% ==============================
% INITIAL CONDITION
%% ==============================

T = zeros(nx,ny);

%% ==============================
% DATASET STORAGE (REDUCED SIZE)
%% ==============================

dataset = [];

sampling_space = 4;   % store every 4th grid point
sampling_time = 5;    % store every 5th timestep

%% ==============================
% TIME LOOP
%% ==============================

for n = 1:nt
    
    T_old = T;
    
    t = n*dt;
    
    for i = 2:nx-1
        
        for j = 2:ny-1
            
            xi = x(i);
            yj = y(j);
            
            Q = Q0 * exp(-((xi - v*t)^2 + yj^2)/sigma^2);
            
            T(i,j) = T_old(i,j) + r*( ...
                T_old(i+1,j) + ...
                T_old(i-1,j) + ...
                T_old(i,j+1) + ...
                T_old(i,j-1) - ...
                4*T_old(i,j)) ...
                + dt*Q;
            
            % REDUCED DATA STORAGE
            
            if mod(i,sampling_space)==0 && ...
               mod(j,sampling_space)==0 && ...
               mod(n,sampling_time)==0
                
                dataset = [dataset;
                    xi yj t T(i,j)];
                
            end
            
        end
        
    end
    
end

%% ==============================
% SURFACE PLOT
%% ==============================

figure
surf(X,Y,T')
title('Temperature Distribution Surface Plot')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Temperature')
shading interp
colorbar

%% ==============================
% CONTOUR PLOT
%% ==============================

figure
contourf(X,Y,T',20)
title('Temperature Contour Plot')
xlabel('X (m)')
ylabel('Y (m)')
colorbar

%% ==============================
% HEAT AFFECTED ZONE
%% ==============================

figure
imagesc(x,y,T')
set(gca,'YDir','normal')
title('Heat Affected Zone Visualization')
xlabel('X (m)')
ylabel('Y (m)')
colorbar

%% ==============================
% CENTERLINE TEMPERATURE
%% ==============================

center_y = round(ny/2);

figure
plot(x,T(:,center_y),'LineWidth',2)
title('Temperature Along Plate Centerline')
xlabel('Plate Length (m)')
ylabel('Temperature')
grid on

%% ==============================
% EXPORT DATASET
%% ==============================

writematrix(dataset,'welding_temperature_dataset_small.csv')

disp('Reduced dataset exported successfully')
