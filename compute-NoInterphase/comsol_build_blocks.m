% 'myfun_comsol_build': build and compute solution from COMSOL 

function [model] = comsol_build_blocks(PScoeff, structure,savefile)
% Initialization
global EpsDistribution GetSolution gridModel epmodel SF

%% Section I: Load Data
comsol_load_constant();

% Step One: Load input dielectric function model, if needed
if EpsDistribution
	comsol_load_epsilon_model(PScoeff);
end

model = mphload(gridModel);
disp('Loaded pre-built model')

model.variable.create('var1');
model.variable('var1').model('mod1');
model.variable('var1').set('ep',epmodel.ep);
model.variable('var1').set('epp',epmodel.epp);
model.variable('var1').set('epint',epmodel.epint);
model.variable('var1').set('eppint',epmodel.eppint);
        
% Step Two: Create statistically re-generated microstructure
model = comsol_create_structure_existing_grid(model, structure);

% Step Four: Create boundary selection indices
indBoundary = comsol_create_boundary_selection(model);

% Step Five: Assign entities with material properties
model       = comsol_create_material_blocks(model);

% Step Six: Create physics
model       = comsol_create_physics_blocks(model,indBoundary);

% Step Seven: Create mesh
model       = comsol_create_mesh(model);

% Step Eight: Assign shift factors for interphase 
model   = comsol_create_shifting_factors(model, SF);

%% Section III:  Obtain solution from COMSOL
% Step One: Create Physics-based Study
model       = comsol_create_study(model);

mphsave(model, 'PRECOMPUTED') % Save temp comsol model file for debug

if GetSolution == 1
    % Step Two: Obtain solution
    model   = comsol_create_solution(model);
    
    % Step Three: Post-processing
    model   = comsol_post_process(model, indBoundary, savefile);
end

end
