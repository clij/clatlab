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
clx = init_clatlab();

% check on which GPU it's running 
string(clx.getGPUName())

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
input = clx.push(image);

% allocate memory for result
maxProjectInput = clx.create([input.getWidth(), input.getHeight()]);
size = clx.op.getSize(input)
output = clx.create([size(3), size(2), size(1)]);
maxProjectOutput = clx.create([output.getWidth(), output.getHeight()]);

% reslice 
clx.op.resliceTop(input, output);

% max project
clx.op.maximumZProjection(input, maxProjectInput);
clx.op.maximumZProjection(output, maxProjectOutput);

% pull results from GPU
maxInput = clx.pull(maxProjectInput);
maxOutput = clx.pull(maxProjectOutput);

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




