% Pixelation of binary image
% ImgFile needs to contain a single variable named 'img_out' with binary
% image matrix

function PixelateBinaryImage(ImgFile, GridSize)

m = GridSize;
load(ImgFile)
img = img_out; 

imgsize = size(img_out);
n = min(imgsize); 
img = img(1:n, 1:n); 

if n > m % Coarsened grid
% Examine each grid block and assign a state
grid = zeros(m,m);
for x = 1:m-1
    for y = 1:m-1
        % x, y are coordinates in grid
        % i, j are coordinates in original binary image
        % Find boundaries from original image
        i1 = floor((x+1)*n/m) ;
        i2 = floor(x*n/m) + 1;
        j1 = floor((y+1)*n/m) ;
        j2 = floor(y*n/m) ;
        is = img(i2:i1, j2:j1);
        vf = sum(sum(is))/ ((i2-i1)^2);
        if vf > 0.5
            grid(x,y)=1;
        else
            grid(x,y)=0;
        end
    end
    
end
OutputGrid = grid;
save([ImgFile,'_2D_voxelated_',num2str(GridSize)], 'OutputGrid')
end