% Create empty grid of size m
function [model] = comsol_create_structure_blocks_grid_2D(model, GridSize)
m = GridSize;
a = 1000/m;
disp('Generating block microstructure ...');
BlockFeature={}; % List of all blocsk
model.disableUpdates(true);
model.hist().disable()

k = 0;
for i = 1:m
    for j = 1:m
        k = k+1;
        if i <= 9 % single digit
            I = ['00',num2str(i)];
            
        elseif i <= 99 % double digit
            I = ['0',num2str(i)];
        else % triple digit
            I = num2str(i);
        end
        if j <= 9 % single digit
            J = ['00',num2str(j)];
        
        elseif j <= 99 % double digit
            J = ['0',num2str(j)];
        else % triple digit
            J = num2str(j);
        end        
        BlockFeature{k} = ['Block',I,J];
        disp(BlockFeature{k})
        X = (i-1)*a;
        Y = (j-1)*a;
        model.geom('geom1').feature.create(BlockFeature{k}, 'Rectangle');
        model.geom('geom1').feature(BlockFeature{k}).set('pos', [X, Y]);
        model.geom('geom1').feature(BlockFeature{k}).set('size', [a, a]);
        model.geom('geom1').feature(BlockFeature{k}).set('createselection', 'on');
        model.geom('geom1').run(BlockFeature{k});
    end
end

model.geom('geom1').runAll;

disp('Finished building block structure.')
