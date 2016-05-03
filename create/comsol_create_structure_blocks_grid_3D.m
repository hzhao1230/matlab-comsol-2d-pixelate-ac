% Create empty grid of size m 
function [model] = comsol_create_structure_blocks_grid_3D(model, GridSize)
m = GridSize;
a = 1000/m; 
disp('Generating block microstructure ...');
BlockFeature={}; % List of all blocsk 
model.disableUpdates(true);
model.hist().disable()

k = 0; 
for i = 1:m
  for j = 1:m
    for l = 1:m
    k = k+1;
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
    if l > 9
      L = num2str(l);
    else
      L = ['0',num2str(l)];    
    end    
    BlockFeature{k} = ['Block',I,J,L];
    disp(BlockFeature{k})
    X = (i-1)*a;
    Y = (j-1)*a;
    Z = (l-1)*a;
    model.geom('geom1').feature.create(BlockFeature{k}, 'Block');
        model.geom('geom1').feature(BlockFeature{k}).set('pos', [X, Y, Z]);
        model.geom('geom1').feature(BlockFeature{k}).set('size', [a, a, a]);
        model.geom('geom1').feature(BlockFeature{k}).set('createselection', 'on');
        model.geom('geom1').run(BlockFeature{k});
    end
  end
end

model.geom('geom1').runAll; 

disp('Finished building block structure.')




