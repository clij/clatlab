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
clear; 

% init CLATLAB and get access to MOCL
clijx = init_clatlab();
mocl = clijx.mocl;

% 3D MOCL buffers in the GPU
a = clijx.pushMat(mocl.push(ones(3,2)))
b = clijx.pushMat(mocl.ones(3,2))
c = size(ones(3, 2))
ones(3, 2)

% 2D MOCL buffer in the GPU
d = clijx.pushMat(mocl.push(ones(3, 4, 2)))
e = clijx.pushMat(mocl.ones(3, 4, 2))
f = size(ones(3, 4, 2))
ones(3, 4, 2)


