% dimensions.m
%
% This is a test script demonstrating that images in CPU memory
% and in GPU memory have the same dimensions and that push/pull
% work correctly.
%
% In order to make this script run, you need to install CLATLAB
%         https://clij.github.io/clatlab/
% 
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clatlab = init_clatlab();
mocl = clatlab.mocl;

% 3D MOCL buffers in the GPU
a = clatlab.push(mocl.push(ones(3,2)))
b = clatlab.push(mocl.ones(3,2))
c = size(ones(3, 2))
ones(3, 2)

% 2D MOCL buffer in the GPU
d = clatlab.push(mocl.push(ones(3, 4, 2)))
e = clatlab.push(mocl.ones(3, 4, 2))
f = size(ones(3, 4, 2))
ones(3, 4, 2)


