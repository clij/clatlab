% spotDetection3D.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing
% to detect spots in 3D and visualise them in MATLAB.
%
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

originalSize = clijx.getSize(input)

% workflow configuration
factor = 1.0;
backgroundSubtractionXY = 5;
backgroundSubtractionZ = 0;
blurXY = 3;
blurZ = 3;
maximumSearch = 1;
thresholdAlgorithm = 'Otsu';

samplingFactor = [
    0.52 * factor
    0.52 * factor  
    3 * factor
];
processingSize = double(originalSize) .* samplingFactor;

downsampled = clijx.create(processingSize);
backgroundSubtracted = clijx.create(processingSize);
blurred = clijx.create(processingSize);
thresholded = clijx.create(processingSize);
detected = clijx.create(processingSize);
masked = clijx.create(processingSize);
labelled = clijx.create(processingSize);
% preprocess
clijx.downsample(input, downsampled, samplingFactor(1), samplingFactor(2), samplingFactor(3));
clijx.subtractBackground(downsampled, backgroundSubtracted, backgroundSubtractionXY, backgroundSubtractionXY, backgroundSubtractionZ);
clijx.blur(backgroundSubtracted, blurred, blurXY, blurXY, blurZ);

% 3D spot detection
clijx.detectMaximaBox(blurred, detected, maximumSearch);

% remove spots in background
clijx.automaticThreshold(blurred, thresholded, thresholdAlgorithm);
clijx.mask(detected, thresholded, masked);	
clijx.connectedComponentsLabeling(masked, labelled);

% read out spot positions
numberOfDetectedSpots = double(clijx.maximumOfAllPixels(labelled));
pointlistSize = [numberOfDetectedSpots double(labelled.getDimension())];
pointlist = clijx.create(pointlistSize, input.getNativeType());
clijx.spotsToPointList(labelled, pointlist);

points = clijx.pullMat(pointlist)';
figure
scatter3(points(1,:), points(2,:), points(3,:))

% visualise data set as maximum projection
maximumProjected = clijx.create(processingSize(1:2), backgroundSubtracted.getNativeType());
clijx.maximumZProjection(backgroundSubtracted, maximumProjected);
figure
imshow(clijx.pullMat(maximumProjected), [0 250]);

maximumProjected.close();
labelled.close();
masked();
backgroundSubtracted.close();
blurred.close();
thresholded.close();
downsampled.close();
input.close();

x = points(1,:);
y = points(2,:);
z = points(3,:);
tri = delaunay(x, y, z)
%trimesh(tri, x, y, z);
figure;
trisurf(tri, x, y, z,'FaceAlpha',0.3)

