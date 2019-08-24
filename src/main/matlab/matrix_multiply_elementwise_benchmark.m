% matrix_multiply_elementwise_benchmarking.m
%
% This script shows how to multiply matrices element wise in the GPU 
% using CLATLAB. It also measures how long it takes.
%
% In order to make this script run, you need to install CLATLAB
%         https://clij.github.io/clatlab/
% 
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% init CLATLAB and get access to MOCL
clatlab = init_clatlab()
mocl = clatlab.mocl;

% create some test data
a = [1 2 3 4 5 6]' * [7 3 4 5 6 7];
b = [1 8 3 4 5 6]' * [3 4 5 6 7 8];

% push test data to the GPU
A = mocl.push(a);
B = mocl.push(b);

% multiply element-wise on GPU
before_gpu = now;
C = A .* B;
duration_gpu = now - before_gpu
c = mocl.pull(C)

% multiply element-wise on CPU
before_cpu = now;
c_ = a .* b
duration_cpu = now - before_cpu