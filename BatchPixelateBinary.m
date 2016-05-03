% convert binary image to filler-matrix voxelated microstructure and
% filler-interphase-matrix voxelated microstructure

clear 
gridsize = 100; 
sidelength = 1000; 
fpath = './microstructure/'; % folder that contains all mat files of binary images

files = dir([fpath,'*.mat']); 
fnames = {files.name};
for i=1:length(fnames)
    fn = [fpath,char(fnames(i))];
    fn = regexprep(fn, '.mat','');
    PixelateBinaryImage(fn, gridsize); % voxelate to filler-matrix structure
    voxelfn = [fn,'_2D_voxelated_',num2str(gridsize)]; 
    AddInterphasePixel(voxelfn, sidelength, 10, 50);
end
