% matrix_multiply.m
%
% This script shows how to multiply matrices in the GPU using CLATLAB.
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

% init CLATLAB and get access to MOCL
clijx = init_clatlab()
mocl = clijx.mocl;

% create some test data
a = [1 2 3]'
b = [1 2 3]

% push it to the GPU and pull it back to see if its fine
A = mocl.push(a).';
a = mocl.pull(A) 
B = mocl.push(b);
b = mocl.pull(B) 

% check sizes and content
size_a = size(a)
size_A = mocl.size(A)
size_b = size(b)
size_B = mocl.size(B)
a
b
% multiply matrices on the GPU
C = A * B;

c = mocl.pull(C)

c_ = a * b