% reslice.m
%
% This script shows how reslice an image stack on the GPU.
%
% In order to make this script run, you need to install CLATLAB an
% run it from matlab. Tested with Matlab 2019b
%         https://clij.github.io/clatlab/
% 
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

% initialize CLATLAB
clijx = init_clatlab();

% check on which GPU it's running 
string(clijx.getGPUName())

% load example data
filename = '../../test/resources/Nantes_000646.tif';
info = imfinfo(filename);
numberOfImages = numel(info);
image = [];
for i = 1:numberOfImages
    plane = imread(filename,i);
    if i == 1
        image = plane;
    else 
        image = cat(3, image, plane);
    end
end 
% image = permute(image, [1 2 3]);

image = double(image);

% size(image);


% push image to GPU memory
input = clijx.pushMat(image);

% allocate memory for result
maxProjectInput = clijx.create([input.getWidth(), input.getHeight()]);
size = clijx.getSize(input)
output = clijx.create([size(3), size(2), size(1)]);
maxProjectOutput = clijx.create([output.getWidth(), output.getHeight()]);

% reslice 
clijx.resliceTop(input, output);

% max project
clijx.maximumZProjection(input, maxProjectInput);
clijx.maximumZProjection(output, maxProjectOutput);

% pull results from GPU
maxInput = clijx.pullMat(maxProjectInput);
maxOutput = clijx.pullMat(maxProjectOutput);

% show results
figure;
subplot(1,2,1);
imshow(maxInput, [100 1000]);
subplot(1,2,2);
imshow(maxOutput, [100 1000]);

% cleanup
input.close();
output.close();
maxProjectInput.close();
maxProjectOutput.close();




