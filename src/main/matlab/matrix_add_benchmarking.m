% matrix_add_benchmarking.m
%
% This script shows how to add matrices in the GPU using CLATLAB.
% It also measures time while adding.
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

A = mocl.ones(1000) * 3 + 5;
B = mocl.ones(1000) * 3 + 5;

before_gpu = now;
% add matrices on the GPU
C = A + B;
duration_gpu = now - before_gpu
C_ = mocl.pull(C);

a = mocl.pull(A);
b = mocl.pull(B);

before_cpu = now;
c_ = a + b;
duration_cpu = now - before_cpu


c_;
