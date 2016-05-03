% Assign entities with material properties
% Assign filler and matrix properties to grid points 

function model = comsol_create_material_blocks(model)
global      MatrixConductivity FillerConductivity FillerRelPerm ElectrodeConductivity ...
		ElectrodeRelPerm InterfaceConductivity InterfaceRelPerm InterfaceImagPerm

% Define filler material
model.material.create('mat1');
model.material('mat1').selection.named('geom1_UnionFiller_dom');
model.material('mat1').propertyGroup('def').set('electricconductivity', FillerConductivity);
model.material('mat1').propertyGroup('def').set('relpermittivity',FillerRelPerm);

% Define matrix material
model.material.create('mat2'); % Matrix
model.material('mat2').selection.named('geom1_UnionMatrix_dom');
model.material('mat2').propertyGroup('def').set('relpermittivity', {'ep-j*epp'});
model.material('mat2').propertyGroup('def').set('electricconductivity', MatrixConductivity); 

disp('Created all materials');
end
