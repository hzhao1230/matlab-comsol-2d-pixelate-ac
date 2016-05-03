% create map mesh
% generate blocks for elements of fillers and interphase only. Matrix is
% left empty in the domain 

clear
close all ;

ImgFile = 'crop_ferroPGMA_2wt%_2';
MeshSize = 500; 
tic
PixelateBinaryImage(ImgFile, MeshSize); 

GridFile = [ImgFile,'_2D_voxelated_',num2str(MeshSize)]; 
l = 1000; % [nm]
IP1 = 10; 
IP2 = 50; 

AddInterphasePixel(GridFile, l, IP1, IP2); 

load([GridFile, '_IP'])
toc