% affineTransform.m
%
% This script demonstrates how to apply an affine transform to an image 
% on the GPU in MATLAB.
%
% Author: Robert Haase, rhaase@mpi-cbg.de
%         October 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% initialize CLATLAB
clatlab = init_clatlab();
clop = clatlab.op;

% load example data
filename = '../../test/resources/blobs.tif';
img = imread(filename);
% there are issues with unit8/int8 conversion; 
% thus, we convert the image to double
img = double(img);

% push image to GPU memory
input = clatlab.push(img);

% reserve memory for output image
transformed = clatlab.create(input1);

% define transform
import net.imglib2.realtransform.AffineTransform2D;
import java.lang.Math;

at = AffineTransform2D();
at.translate([-input.getWidth() / 2, -input.getHeight() / 2]);
at.rotate(45.0 / 180.0 * Math.PI);
at.scale(0.5);
at.translate([input.getWidth() / 2, input.getHeight() / 2]);

% transform image os GPU
clatlab.op.affineTransform2D(input, transformed, at);

% pull result image back
result = clatlab.pull(transformed);
imshow(result, [0 255]);

% clean up
input.close();
transformed.close();



