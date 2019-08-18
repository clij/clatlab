% simplePipeline.m
%
% This script shows how to run CLATLAB for GPU accelerated image processing from MATLAB.
%
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% initialize CLATLAB by adding all its jar files to the java classpath

% todo: when calling the following block the second time, warnings are thrown
%       we cannot call clear java as dll files cannot be cleared and thus
%       not reloaded...
clatlab_folder = '../../../classpath/';
javaaddpath(strcat(clatlab_folder, 'clatlab-0.1.0.jar'));
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

% check class path
% javaclasspath()

% check java version
% version -java 

% load example data
filename = '../resources/blobs.tif';
img = imread(filename);
% there are issues with unit8/int8 conversion; 
% thus, we convert the image to double
img = double(img);

% show input image in a subplot
subplot(1,2,1), imshow(img, [0 255]);

% import and initialize CLATLAB
clatlab = net.haesleinhuepf.clatlab.CLATLAB.getInstance();

% check on which GPU it's running 
string(clatlab.getGPUName())

% push image to GPU memory
input = clatlab.push(img);
% reserve memory for output image
output = clatlab.create(input);

% blur the image
import java.lang.Float;
clatlab.op().blur(input, output, Float(5), Float(5));

% pull result back from GPU
result = clatlab.pull(output);

% show result
subplot(1,2,2), imshow(result, [0 255]);

% clean up
input.close();
output.close();

