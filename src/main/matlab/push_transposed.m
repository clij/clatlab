% push_transposed.m
%
% This script demonstrates and issue with pushing transposed vectors to
% the GPU.
%
% In order to make this script run, you need to install CLATLAB
%         https://clij.github.io/clatlab/
% 
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

clx = init_clatlab()
mocl = clx.mocl;

a = [1 2 3]
b = [1 2 3]'

size_a = size(a)
size_b = size(b)

% when pushing two vectors 1x3 and 3x1 to the GPU
A = mocl.push(a);
B = mocl.push(b);

% they both arrived there as 3x1 vector.
size_A = mocl.size(A)
size_B = mocl.size(B)

% workaround: transpose in the GPU:
size_B_transposed = mocl.size(B.')

