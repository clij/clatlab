% init_clatlab.m
%
% This is a utiliy function simplifying CLATLAB initialisation.
% You may have to change clatlab_folder variable below to fit your needs.
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

function clatlab_ = init_clatlab()
    if (exist('net.haesleinhuepf.clatlab.CLATLAB') ~= 8)
		jar_location = strrep(mfilename('fullpath'), 'init_clatlab', 'clatlab-2.0.0.10-jar-with-dependencies.jar');
        javaaddpath(jar_location);        
    end
    clatlab_ = net.haesleinhuepf.clatlab.CLATLAB.getInstance();
end
