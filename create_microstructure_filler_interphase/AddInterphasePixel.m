function AddInterphasePixel(GridFile, l, IP1, IP2)
% input:
% gridfile: filename of file that contains variable 'OutputGrid' of N by N matrix
% for microstructure
% l: physical length [nm] of each side
% IP1, IP2: physical length [nm] of interphase thicknesses

% output:
% GridIP: output grid including interphase pixels

load(GridFile)
Grid = OutputGrid;
m = length(OutputGrid);
a = l/m; % [nm] physical length of each block
mIP1 = ceil(IP1/a);
mIP2 = ceil(IP2/a);

ci = [];cj=[]; % coordinates of filler
for i=1:m
    for j=1:m
        if Grid(i,j)==1
            ci=[ci,i];
            cj=[cj,j];
        end
    end
end
disp('Finished reading all fillers.')
nf = length(ci);
disp('Number of fillers')
disp(nf)

D = [];
for i=1:m
    if mod(i, 30) ==0
        disp('Row')
        disp(i)
    end
    for j=1:m
        if Grid(i,j)==0
            for n=1:nf
                % calculate distance from each filler
                fi = ci(n);
                fj = cj(n);
                d = sqrt((i-fi)^2 + (j-fj)^2);
                D=[D,d];
                % check if distance is within thin interphase thickness
                if d <= mIP1
                    Grid(i,j)=2;
                end
                % check if distance is within thick interphase thickness
                if Grid(i,j)==0 && d<=mIP2
                    Grid(i,j)=3;
                end
            end
        end
    end
    
end
OutputGridIP = Grid;
save([GridFile, '_IP'], 'OutputGridIP');