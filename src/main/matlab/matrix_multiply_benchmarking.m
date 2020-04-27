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

% init CLATLAB
clij2 = init_clatlab()
clij2.clear();

% create some test data
a = rand(5000, 1000);
b = rand(1000, 5000);

time_before_gpu = now;

% push it to the GPU
A = clij2.pushMat(a);
B = clij2.pushMat(b);

% multiply matrices on the GPU
C = clij2.create(3, 3);
clij2.multiplyMatrix(A, B, C);

c = clij2.pullMat(C);

time_after_gpu = now;

time_before_cpu = now;
c_ = a * b;
time_after_cpu = now;

duration_gpu = time_after_gpu - time_before_gpu
duration_cpu = time_after_cpu - time_before_cpu
