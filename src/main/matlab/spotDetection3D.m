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

import java.lang.Float;
import java.lang.Integer;
% clatlab.op().blur(input, temp, Float(1), Float(1), Float(1));

originalSize = clx.op.getSize(input)

% workflow configuration
factor = 1.0;
backgroundSubtractionXY = Float(5);
backgroundSubtractionZ = Float(0);
blurXY = Float(3);
blurZ = Float(3);
maximumSearch = Integer(1);
thresholdAlgorithm = 'Otsu';

samplingFactor = [
    0.52 * factor
    0.52 * factor  
    3 * factor
];
processingSize = double(originalSize) .* samplingFactor;

downsampled = clx.create(processingSize);
backgroundSubtracted = clx.create(processingSize);
blurred = clx.create(processingSize);
thresholded = clx.create(processingSize);
detected = clx.create(processingSize);
masked = clx.create(processingSize);
labelled = clx.create(processingSize);
% preprocess
clx.op.downsample(input, downsampled, Float(samplingFactor(1)), Float(samplingFactor(2)), Float(samplingFactor(3)));
clx.op.subtractBackground(downsampled, backgroundSubtracted, backgroundSubtractionXY, backgroundSubtractionXY, backgroundSubtractionZ);
clx.op.blur(backgroundSubtracted, blurred, blurXY, blurXY, blurZ);

% 3D spot detection
clx.op.detectMaximaBox(blurred, detected, maximumSearch);

% remove spots in background
clx.op.automaticThreshold(blurred, thresholded, thresholdAlgorithm);
clx.op.mask(detected, thresholded, masked);	
clx.op.connectedComponentsLabeling(masked, labelled);

% read out spot positions
numberOfDetectedSpots = double(clx.op.maximumOfAllPixels(labelled));
pointlistSize = [numberOfDetectedSpots double(labelled.getDimension())];
pointlist = clx.create(pointlistSize, input.getNativeType());
clx.op.spotsToPointList(labelled, pointlist);

points = clx.pull(pointlist)';
figure
scatter3(points(1,:), points(2,:), points(3,:))

% visualise data set as maximum projection
maximumProjected = clx.create(processingSize(1:2), backgroundSubtracted.getNativeType());
clx.op.maximumZProjection(backgroundSubtracted, maximumProjected);
figure
imshow(clx.pull(maximumProjected), [0 250]);

maximumProjected.close();
labelled.close();
masked();
backgroundSubtracted.close();
blurred.close();
thresholded.close();
downsampled.close();
input.close();
