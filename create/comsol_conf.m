% comsol_conf.m
% Create empty COMSOL grid for voxelated study

% Run this command before running this file.
% addpath('/usr/local/comsol52/multiphysics/mli','/usr/local/comsol52/multiphysics/mli/startup');
% Then use 'mphstart(portNum)' to connect MATLAB with COMSOL server

clear all; close all; clc; warning('off', 'all')

GridSize = 5; % Side length of simulation domain in pixels
dim = 2; 

savefile = ['./GridOnly_Dim',num2str(dim),'_',num2str(GridSize)]; % Output COMSOL project name
tic
import com.comsol.model.*
import com.comsol.model.util.*
model = ModelUtil.create('Model');
model.modelNode.create('mod1');
model.geom.create('geom1', dim);
model.geom('geom1').lengthUnit(['nm']);
if dim == 2
    model = comsol_create_structure_blocks_grid_2D(model,GridSize);
elseif dim == 3
    model = comsol_create_structure_blocks_grid_3D(model,GridSize);
else 
    disp('ERROR: Dim has to be either 2 or 3.')
end
mphsave(model, savefile);
toc
