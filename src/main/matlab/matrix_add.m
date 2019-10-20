% matrix_add.m
%
% This script shows how to add matrices in the GPU using CLATLAB.
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
A = mocl.ones(10, 1) * 6 + 8;
B = mocl.ones(10, 1) * 67 + 6;

% add matrices on the GPU
C = A + B;

a = ones(10, 1) * 6 + 8;
b = ones(10, 1) * 67 + 6;

% show result (GPU and CPU)
c = mocl.pull(C)
c_ = a + b
