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
clear;

% init CLATLAB and get access to MOCL
clx = init_clatlab();
mocl = clx.mocl;

% create some test data on the GPU
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
