% comsol_conf.m
% Configuration files for COMSOL model using API

clear; close all; clc; warning('off', 'all')
global epmodel ...
    EpsDistribution ...
    GetSolution  ...
    ManualMesh MeshLevel ...
    tau0 gridModel GridSideLength dimensionX dimensionY SF InterfaceRelPerm InterfaceImagPerm

% --------------user defined input ------------------------
id 						= 3; % current run ID
exptdata = '../expt_epoxy_DS/ferrocene_PGMA_2wt-TK.csv';
GetSolution             = 1; % '1' for getting solution. '0' for outputing a MPH model with just simulation setup w/o running simulation
gridModel               = 'GridOnly_50.mph'; % comsol empty grid geometry
structure               = './GridFile_50_IP'; % binary microstructure
parameter_file = '../sample_parameters_no_string.csv';
confpara = csvread(parameter_file);

% Interphaes shift factors
TauShift1 		        = confpara(id,3);      % beta relaxation, s_beta, For tau <= 1, Shift multiplier along x direction. 1 is no shift
DeltaEpsilonShift1 	    = confpara(id,4); 	% beta relaxation, M_beta, For tau <= 1, Shift multiplier along y direction. 1 is no shift
TauShift2 		        = confpara(id,5); 	% Alpha relaxation, s_alpha, for tau > 1, Shift multiplier along x direction. 1 is no shift
DeltaEpsilonShift2		= confpara(id,6);  	% Alpha relaxation, M_alpha, For tau > 1, Shift multiplier along y direction. 1 is no shift
ConstEpsilonShift		= confpara(id,7); 	% Constant vertical shift for real permittivity
tau0                    = confpara(id,2); 	% tau*freq_crit = 1. E.g, for freq_crit = 10 Hz, tau = 0.1 s.
if confpara(id,8) < 50
    InterfaceRelPerm        = confpara(id,8);                     % Relative permittivity of IF1
    InterfaceImagPerm       = confpara(id,9);
end

SF  	= [TauShift1, DeltaEpsilonShift1, TauShift2, DeltaEpsilonShift2, ConstEpsilonShift];

disp(GridSideLength)

% neat polymer properties
PolymerPronySeries   = './RoomTempEpoxy.mat';

% -------------- end user defined input ------------------------

% -------------- model config parameters ------------------------
dimensionX              =  1000; % Simulation size
dimensionY              = dimensionX;

EpsDistribution 	= 1;            % '1' for using dielectric relaxation distribution, rather than a fixed value
ManualMesh          = 0;    		% '1' for manual mesh. meshing parameters are defined in comsol_create_mesh.m
MeshLevel           = 7;            % Use when ManualMesh = 0. Range from 1 to 9 (finest to most coarse)

% No-relaxation polymer matrix (non-epoxy)
if EpsDistribution == 0;
    % polymer permittivity
    epmodel.ep		= 2;
    epmodel.epp 	= 1e-3;
    % fixed interphase permittivity shift
    epintShift 		= 0;
    epmodel.epint 	= epmodel.ep + epintShift;
    eppintShift 	= 0;
    epmodel.eppint 	= epmodel.epp + eppintShift;
end
% -------------- end model config parameters ------------------------

% Run Model
savefile = ['./LoadGrid_',date,'_run_',num2str(id),'_',num2str(GetSolution),'_50']; % Output COMSOL project name
tic
model = comsol_build_blocks(PolymerPronySeries, structure, savefile);
disp('Job done. Output result to .mph file');
mphsave(model, savefile);
plot_results(savefile, exptdata)
toc
