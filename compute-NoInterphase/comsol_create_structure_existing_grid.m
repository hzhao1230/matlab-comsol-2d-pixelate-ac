function [model] = comsol_create_structure_existing_grid(model, structure)

% Assign filler and matrix to blocks
load(structure)
m = length(OutputGrid);
FillerFeature={}; % List of filler blocks
MatrixFeature={}; % List of matrix blocks
nf = 0; % Counter for filler blocks
nm = 0; % Counter for matrix blocks
for i=1:m
    for j=1:m
        if i > 9
            I = num2str(i);
        else
            I = ['0',num2str(i)];
        end
        if j > 9
            J = num2str(j);
        else
            J = ['0',num2str(j)];
        end
        if OutputGrid(i,j)==1
            % matrix
            nm = nm+1;
            MatrixFeature{nm}=['Block',I,J];
        else 
            % filler
            nf = nf+1;
            FillerFeature{nf}=['Block',I,J];
        end
    end
end
% Make union of fillers and matrix
model.geom('geom1').feature.create('UnionFiller', 'Union');
model.geom('geom1').feature('UnionFiller').selection('input').set(FillerFeature);
model.geom('geom1').feature('UnionFiller').set('createselection', 'on');
model.geom('geom1').feature('UnionFiller').set('intbnd', 'off');

model.geom('geom1').feature.create('UnionMatrix', 'Union');
model.geom('geom1').feature('UnionMatrix').selection('input').set(MatrixFeature);
model.geom('geom1').feature('UnionMatrix').set('createselection', 'on');
model.geom('geom1').feature('UnionMatrix').set('intbnd', 'off');
model.geom('geom1').runAll;

disp('Finished building block structure.')
