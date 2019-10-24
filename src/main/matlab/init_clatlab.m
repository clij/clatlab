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
        clatlab_folder = '../../../classpath/';
        javaaddpath(strcat(clatlab_folder, 'ij-1.52p.jar'));
        javaaddpath(strcat(clatlab_folder, 'clatlab-0.4.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'bridj-0.7.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij_-1.4.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-clearcl-0.10.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-core-1.4.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-coremem-0.6.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-legacy_-0.1.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'imagej-common-0.28.2.jar'));
        javaaddpath(strcat(clatlab_folder, 'imglib2-5.6.3.jar'));
        javaaddpath(strcat(clatlab_folder, 'imglib2-realtransform-2.1.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'jocl-2.0.1.jar'));
        javaaddpath(strcat(clatlab_folder, 'scijava-common-2.76.1.jar'));
        javaaddpath(strcat(clatlab_folder, 'imglib2-ij-2.0.0-beta-44.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-advanced-filters_-0.11.0.jar'));

        % import and initialize CLATLAB

        
    end
    clatlab_ = net.haesleinhuepf.clatlab.CLATLAB.getInstance();
end