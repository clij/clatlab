% spotDetection3D.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing
% to detect spots in 3D and visualise them in MATLAB.
%
% In order to make this script run, you need to install CLATLAB
%         https://clij.github.io/clatlab/
% 
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize CLATLAB by adding all its jar files to the java classpath

% todo: when calling the following block the second time, warnings are thrown
%       we cannot call clear java as dll files cannot be cleared and thus
%       not reloaded...
if (exist('clatlab') == 0)
    clatlab_folder = '../../../classpath/';
    javaaddpath(strcat(clatlab_folder, 'ij-1.52p.jar'));
    javaaddpath(strcat(clatlab_folder, 'clatlab-0.2.0.jar'));
    javaaddpath(strcat(clatlab_folder, 'bridj-0.7.0.jar'));
    javaaddpath(strcat(clatlab_folder, 'clij_-1.1.4.jar'));
    javaaddpath(strcat(clatlab_folder, 'clij-clearcl-0.8.4.jar'));
    javaaddpath(strcat(clatlab_folder, 'clij-core-1.1.4.jar'));
    javaaddpath(strcat(clatlab_folder, 'clij-coremem-0.5.5.jar'));
    javaaddpath(strcat(clatlab_folder, 'clij-legacy_-0.1.0.jar'));
    javaaddpath(strcat(clatlab_folder, 'imagej-common-0.28.2.jar'));
    javaaddpath(strcat(clatlab_folder, 'imglib2-5.6.3.jar'));
    javaaddpath(strcat(clatlab_folder, 'imglib2-realtransform-2.1.0.jar'));
    javaaddpath(strcat(clatlab_folder, 'jocl-2.0.1.jar'));
    javaaddpath(strcat(clatlab_folder, 'scijava-common-2.76.1.jar'));
    javaaddpath(strcat(clatlab_folder, 'clij-advanced-filters_-0.6.1.jar'));

    % import and initialize CLATLAB
    clatlab = net.haesleinhuepf.clatlab.CLATLAB.getInstance();
end 
% check on which GPU it's running 
string(clatlab.getGPUName())


% check class path
% javaclasspath()

% check java version
% version -java 

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
image = permute(image, [3 2 1]);

image = double(image);

% size(image);


% push image to GPU memory
input = clatlab.push(image);

import java.lang.Float;
import java.lang.Integer;
% clatlab.op().blur(input, temp, Float(1), Float(1), Float(1));

originalSize = clatlab.op().getSize(input)

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

downsampled = clatlab.create(processingSize);
backgroundSubtracted = clatlab.create(processingSize);
blurred = clatlab.create(processingSize);
thresholded = clatlab.create(processingSize);
detected = clatlab.create(processingSize);
masked = clatlab.create(processingSize);
labelled = clatlab.create(processingSize);
% preprocess
clatlab.op().downsample(input, downsampled, Float(samplingFactor(1)), Float(samplingFactor(2)), Float(samplingFactor(3)));
clatlab.op().subtractBackground(downsampled, backgroundSubtracted, backgroundSubtractionXY, backgroundSubtractionXY, backgroundSubtractionZ);
clatlab.op().blur(backgroundSubtracted, blurred, blurXY, blurXY, blurZ);

% 3D spot detection
clatlab.op().detectMaximaBox(blurred, detected, maximumSearch);

% remove spots in background
clatlab.op().automaticThreshold(blurred, thresholded, thresholdAlgorithm);
clatlab.op().mask(detected, thresholded, masked);	
clatlab.op().connectedComponentsLabeling(masked, labelled);

% read out spot positions
numberOfDetectedSpots = double(clatlab.op().maximumOfAllPixels(labelled));
pointlistSize = [numberOfDetectedSpots double(labelled.getDimension())];
pointlist = clatlab.create(pointlistSize, input.getNativeType());
clatlab.op().spotsToPointList(labelled, pointlist);

points = clatlab.pull(pointlist)';
figure
scatter3(points(:,1), points(:,2), points(:,3))

% visualise data set as maximum projection
maximumProjected = clatlab.create(processingSize(1:2), backgroundSubtracted.getNativeType());
clatlab.op().maximumZProjection(backgroundSubtracted, maximumProjected);
figure
imshow(clatlab.pull(maximumProjected), [0 250]);

maximumProjected.close();
labelled.close();
masked();
backgroundSubtracted.close();
blurred.close();
thresholded.close();
downsampled.close();
input.close();
