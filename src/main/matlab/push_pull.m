% push_pull.m
%
% This script shows how to push data to the GPU and back using CLATLAB.
%
%
% In order to make this script run, you need to install CLATLAB an
% run it from matlab. Tested with Matlab 2019b
%         https://clij.github.io/clatlab/
%
% In order to make this script run, you need to install CLATLAB
%         https://clij.github.io/clatlab/
% 
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

% multiply element-wise on GPU
clx = init_clatlab();
mocl = clx.mocl

% push some data to the GPU as ClearCL data structure
A = clx.push([1 2 3])

% pull it back
a = clx.pull(A)

% push data to GPU and get it back as MOCL buffer;
% mocl buffers can partly be treated like matlab arrays,
% they have overloaded operators
B = mocl.push([1 2 3])

% pull it back
b = mocl.pull(A)