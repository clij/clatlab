% init_clatlab.m
%
% This is a utiliy function simplifying CLATLAB initialisation.
% You may have to change clatlab_folder variable below to fit your needs.
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

function clatlab_ = init_clatlab(gpu_name)
    if (exist('net.haesleinhuepf.clatlab.CLATLAB') ~= 8)
		jar_location = strrep(mfilename('fullpath'), 'init_clatlab', 'clatlab-2.5.1.4-jar-with-dependencies.jar');
        javaaddpath(jar_location);
    end

    if ~exist('gpu_name','var')
        gpu_name = "";
    end

    clatlab_ = net.haesleinhuepf.clatlab.CLATLAB.getInstance(gpu_name);
end
