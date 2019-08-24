% init_clatlab.m
%
% This is a utiliy function simplifying CLATLAB initialisation.
% You may have to change clatlab_folder variable below to fit your needs.
%
% In order to make this script run, you need to install CLATLAB
%         https://clij.github.io/clatlab/
% 
% Author: Robert Haase, rhaase@mpi-cbg.de
%         August 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function clatlab_ = init_clatlab()
    if (exist('clatlab') == 0)
        clatlab_folder = '../../../classpath/';
        javaaddpath(strcat(clatlab_folder, 'ij-1.52p.jar'));
        javaaddpath(strcat(clatlab_folder, 'clatlab-0.2.1.jar'));
        javaaddpath(strcat(clatlab_folder, 'bridj-0.7.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij_-1.1.4.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-clearcl-0.8.4.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-core-1.1.4.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-coremem-0.5.5.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-legacy_-0.1.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'imagej-common-0.28.2.jar'));
        javaaddpath(strcat(clatlab_folder, 'imglib2-5.6.3.jar'));
        javaaddpath(strcat(clatlab_folder, 'imglib2-realtransform-2.1.0.jar'));
        javaaddpath(strcat(clatlab_folder, 'jocl-2.0.1.jar'));
        javaaddpath(strcat(clatlab_folder, 'scijava-common-2.76.1.jar'));
        javaaddpath(strcat(clatlab_folder, 'clij-advanced-filters_-0.6.2.jar'));

        % import and initialize CLATLAB

        clatlab = net.haesleinhuepf.clatlab.CLATLAB.getInstance();
    end
    clatlab_ = clatlab;
end