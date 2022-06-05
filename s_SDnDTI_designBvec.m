%% introduction

% s_SDnDTI_designBvec.m
% 
%   A script for designing diffusion encoding directions for SDnDTI.
%
%   Source code:
%       https://github.com/qiyuantian/SDnDTI/blob/main/s_SDnDTI_designBvec.m
%
%   HTML file can be automatically generaged using command:
%       publish('s_SDnDTI_designBvec.m', 'html');
%
%   Reference:
%       [1] Tian Q, Li Z, Fan Q, Polimeni JR, Bilgic B, Salat DH, Huang SY.
%       SDnDTI: Self-supervised deep learning-based denoising for diffusion
%       tensor MRI. NeuroImage, 2022; 253: 119033.
%
% (c) Qiyuan Tian, Harvard, 2022

%% define a set of optimized encoding directions

clear, clc, close all

% 6 optimized directions from the DSM scheme that minimizes the condition
% number of the diffusion tensor transformation matrix
% from S Skare et al., J Magn Reson. 2000;147(2):340-52
% 10, 20, 30 (dsm10.m, dsm20.m, dsm30.m) or more directions can be used for 
% very noisy data
dsm6 = [0.91, 0.416, 0; ...
       0, 0.91, 0.416; ...
       0.416, 0, 0.91; ...
       0.91, -0.416, 0; ...
       0, 0.91, -0.416; ...
      -0.416, 0, 0.91];

dsm6_norm = dsm6 ./ sqrt(dsm6(:, 1) .^ 2 + dsm6(:, 2) .^ 2 + dsm6(:, 3) .^ 2); % normalize vectors

figure % display dsm6 
plot3(dsm6_norm(:, 1), dsm6_norm(:, 2), dsm6_norm(:, 3), '.');

grid on, axis equal
xlim([-1, 1])
ylim([-1, 1])
zlim([-1, 1])
title('6 optimal directions');

%% design uniform bvecs on z>0 hemisphere

% (1) select N sets, with each set as a random rotation of dsm6

% (2) directions from all sets are uniformly distributed on z>0 hemisphere
% (since v and -v are identical for diffusion encoding) to maximize angular
% coverage

N = 5; % select 5 sets as an example, so in total of 5x6=30 dirs
bvecs_hemi = []; % designed diffusion encoding directions
unif_min = 10^10; % init using a large number

for ii = 1 : 100000 % number of iterations can be increased for better results
    
    dirs_all = []; % all 30 directions
    
    for jj = 1 : N
        rotangs = rand(1, 3) * 2 * pi; % random angles to rotate around x, y, z axis
        R = rot3d(rotangs); % rotation matrix
        dsm6_rot = (R * dsm6_norm')'; % roated directions
        
        dirs_all = [dirs_all; dsm6_rot];
    end
        
    % [v; -v] is used for optimization such that v is uniformly distributed
    % on z>0 hemisphere
    dirs_tmp = [dirs_all; -dirs_all];
    
    % uniformly distributed directions have lowest electrostatic potential energy
    % details see Jones Magn. Reson. Med., 51 (2004), pp. 807-815
    unif = potentialenergy(dirs_tmp); % uniformity of all 30 directions
    
    if unif < unif_min % keep new directions if uniformity is better
        unif_min = unif;
        bvecs_hemi = dirs_all;
        disp(unif_min)
    end
end

n = size(bvecs_hemi, 1) / N;

figure; % display designed directions
for ii = 1 : N
    idxs = (ii - 1) * n + 1;
    idxe = ii  * n;
    bvecs_vis = bvecs_hemi(idxs:idxe, :);
    bvecs_vis = [bvecs_vis; -bvecs_vis];
        
    plot3(bvecs_vis(:, 1), bvecs_vis(:, 2), bvecs_vis(:, 3), '.'); % each color represents a set
    hold on
end
    
grid on, axis equal
xlim([-1, 1])
ylim([-1, 1])
zlim([-1, 1])
title('bvecs and -bvecs together are uniform on whole sphere ');

figure
for ii = 1 : N
    idxs = (ii - 1) * n + 1;
    idxe = ii  * n;
    bvecs_vis = bvecs_hemi(idxs:idxe, :);
    
    tmp = sign(bvecs_vis(:, 3));
    tmp(tmp == 0) = 1;
    bvecs_vis = bvecs_vis .* tmp; % flip dirs with z<0 to z>0
    
    plot3(bvecs_vis(:, 1), bvecs_vis(:, 2), bvecs_vis(:, 3), '.'); % each color represents a set
    hold on
end
    
grid on, axis equal
xlim([-1, 1])
ylim([-1, 1])
zlim([-1, 1])
title('bvecs only uniform on z>0 hemisphere');

%% design uniform bvecs on a whole sphere

% this helps eddy current correction using FSL's eddy function, since
% eddy-induced iamge distortions from opposite diffusion encoding
% directions are opposite

bvecs_whole = []; % finally optimized bvecs for SDnDTI data acquisition
unif_min = 10^10; % init using a large number

for ii = 1 : 100000 % number of iterations can be increased for better results

    r = sign(rand(size(bvecs_hemi, 1), 1) - 0.5); % random vector to flip each dir
    dirs_tmp = bvecs_hemi .* r; % flip dirs
    unif = potentialenergy(dirs_tmp); % uniformity
    
    if unif < unif_min % keep new directions if uniformity is better
        unif_min = unif;
        bvecs_whole = dirs_tmp;
        disp(unif_min)
    end
end

figure; % display designed directions
for ii = 1 : N
    idxs = (ii - 1) * n + 1;
    idxe = ii  * n;
    bvecs_vis = bvecs_hemi(idxs:idxe, :);
        
    plot3(bvecs_vis(:, 1), bvecs_vis(:, 2), bvecs_vis(:, 3), '.'); % each color represents a set
    hold on
end
    
grid on, axis equal
xlim([-1, 1])
ylim([-1, 1])
zlim([-1, 1])
title('bvecs only uniform on hemisphere');

figure
for ii = 1 : N
    idxs = (ii - 1) * n + 1;
    idxe = ii  * n;
    bvecs_vis = bvecs_whole(idxs:idxe, :);
        
    plot3(bvecs_vis(:, 1), bvecs_vis(:, 2), bvecs_vis(:, 3), '.'); % each color represents a set
    hold on
end
    
grid on, axis equal
xlim([-1, 1])
ylim([-1, 1])
zlim([-1, 1])
title('bvecs uniform on both hemi & whole sphere');

%% DeepDTI pipeline 

% subsequent data preparation and CNN training and application follows DeepDTI 
% see codes here: https://github.com/qiyuantian/DeepDTI

% diffusion weighted images (DWIs) from each set, which are optimal for
% diffusion tensor fitting, serve as input for CNNs

% DWIs from all sets serve as target of CNNs




