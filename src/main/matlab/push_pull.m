% push_pull.m
%
% This script shows how to push data to the GPU and back using CLATLAB.
%
% In order to make this script run, you need to install CLATLAB
%         https://clij.github.io/clatlab/
% 
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% multiply element-wise on GPU
clatlab = init_clatlab();
mocl = clatlab.mocl

% push some data to the GPU as ClearCL data structure
A = clatlab.push([1 2 3])

% pull it back
a = clatlab.pull(A)

% push data to GPU and get it back as MOCL buffer;
% mocl buffers can partly be treated like matlab arrays,
% they have overloaded operators
B = mocl.push([1 2 3])

% pull it back
b = mocl.pull(A)