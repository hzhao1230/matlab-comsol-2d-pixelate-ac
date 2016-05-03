% Apr 29, 2016. Add interphase

function [model] = comsol_create_structure_existing_grid_IP(model, structure)

% Assign filler and matrix to blocks
load(structure)
Grid = OutputGridIP;
m = length(Grid); % side length in pixel

FillerFeature={}; % List of filler blocks
MatrixFeature={}; % List of matrix blocks
IP1Feature={}; % List of intrinsic interphase features
IP2Feature={}; % extrinsic interphase
nf = 0; % Counter for filler blocks
nm = 0; % Counter for matrix blocks
nip1 = 0;
nip2 = 0;
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
        if Grid(i,j)==0
            % matrix
            nm = nm+1;
            MatrixFeature{nm}=['Block',I,J];
        elseif Grid(i,j)==1
            % filler
            nf = nf+1;
            FillerFeature{nf}=['Block',I,J];
        elseif Grid(i,j)==2
            % intrinsic ip
            nip1 = nip1+1;
            IP1Feature{nip1}=['Block',I,J];
        elseif Grid(i,j)==3
            % filler
            nip2 = nip2+1;
            IP2Feature{nip2}=['Block',I,J];
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

model.geom('geom1').feature.create('UnionIP1', 'Union');
model.geom('geom1').feature('UnionIP1').selection('input').set(IP1Feature);
model.geom('geom1').feature('UnionIP1').set('createselection', 'on');
model.geom('geom1').feature('UnionIP1').set('intbnd', 'off');

model.geom('geom1').feature.create('UnionIP2', 'Union');
model.geom('geom1').feature('UnionIP2').selection('input').set(IP2Feature);
model.geom('geom1').feature('UnionIP2').set('createselection', 'on');
model.geom('geom1').feature('UnionIP2').set('intbnd', 'off');
model.geom('geom1').runAll;


disp('Finished building block structure.')
