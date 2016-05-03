% comsol_conf.m
% Configuration files for COMSOL model using API

clear all; close all; clc; warning('off', 'all')
global epmodel ...  			
    EpsDistribution ...     
    GetSolution  ... 		
    ManualMesh MeshLevel ...
    tau0 gridModel GridSideLength dimensionX dimensionY SF
	
% --------------user defined input ------------------------
id 						= 1; % current run ID
GetSolution             = 1; % '1' for getting solution. '0' for outputing a MPH model with just simulation setup w/o running simulation
gridModel               = 'GridOnly_50.mph'; % comsol empty grid geometry
structure               = './GridFile_50'; % binary microstructure 

% Interphaes shift factors
TauShift1 		        = 0.75;       % beta relaxation, s_beta, For tau <= 1, Shift multiplier along x direction. 1 is no shift
DeltaEpsilonShift1 	    = 1.8;  	% beta relaxation, M_beta, For tau <= 1, Shift multiplier along y direction. 1 is no shift
TauShift2 		        = 0.006;  	% Alpha relaxation, s_alpha, for tau > 1, Shift multiplier along x direction. 1 is no shift
DeltaEpsilonShift2		= 1.4;  	% Alpha relaxation, M_alpha, For tau > 1, Shift multiplier along y direction. 1 is no shift
ConstEpsilonShift		= 0.3; 	% Constant vertical shift for real permittivity
tau0                    = 0.01; 	% tau*freq_crit = 1. E.g, for freq_crit = 10 Hz, tau = 0.1 s. 
SF  	= [TauShift1, DeltaEpsilonShift1, TauShift2, DeltaEpsilonShift2, ConstEpsilonShift];

disp(GridSideLength)
%% experimental dielectric relaxation data 
%exptdata = '../expt_epoxy_DS/ferrocene_PGMA_2wt-TK.csv'; 

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
savefile = ['./LoadGrid_',date,'_run_',num2str(id),'_',num2str(GetSolution),'_100']; % Output COMSOL project name
tic
model = comsol_build_blocks(PolymerPronySeries, structure, savefile);
disp('Job done. Output result to .mph file');
mphsave(model, savefile);

%% Plot computed results and compare against expt data
% plot_results(savefile, exptdata)
toc
