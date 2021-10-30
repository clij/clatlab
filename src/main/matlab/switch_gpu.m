% switch_gpu.m
%
% This script shows how to list available GPUs and how to select them for computing.
%
%
% In order to make this script run, you need to install CLATLAB an
% run it from matlab. Tested with Matlab 2020b
%         https://clij.github.io/clatlab/
%
% Author: Robert Haase, robert.haase@tu-dresen.de
%         November 2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

% initialize CLATLAB
clij2 = init_clatlab();
clij2.getGPUName()

disp("Available GPUs:");
net.haesleinhuepf.clij.CLIJ.getAvailableDeviceNames()

clij2 = init_clatlab("Radeon");
clij2.getGPUName()

clij2 = init_clatlab("Intel");
clij2.getGPUName()
