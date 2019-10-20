% init_arrrays.m
%
% This is a test script for initializing arrays in CPU an GPU memory.
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
clx = init_clatlab();
mocl = clx.mocl;

% an array containing 1
A = mocl.ones(3)
a = mocl.pull(A)
a_ = ones(3)

% an array containing 0
B = mocl.zeros(4)
b = mocl.pull(B)
b_ = zeros(4)

D = mocl.zeros(3, 1)
d = mocl.pull(D)
d_ = zeros(3, 1)

E = mocl.zeros(3, 2, 1)
e = mocl.pull(E)
e_ = zeros(3, 2, 1)

F = mocl.zeros(4, 3, 2)
f = mocl.pull(F)
f_ = zeros(4, 3, 2)

g = mocl.pull(mocl.colon(0, 4))
g_ = (0:4)

h = mocl.pull(mocl.colon(0, 2, 8))
h_ = (0:2:8)
