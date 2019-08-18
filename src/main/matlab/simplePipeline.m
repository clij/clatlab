
filename = '../resources/blobs.tif'

A = imread(filename)
imshow(A)


% todo: when calling the following block the second time, warnings are thrown
%       we cannot call clear java as dll files cannot be cleared and thus
%       not reloaded...
clatlab_folder = '../../../target/';
javaaddpath(strcat(clatlab_folder, 'clablab-0.1.0.jar'));
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

a = javaclasspath()

version -java 

a1 = java.lang.Double(100);
a2 = java.lang.Float(200);
%a3 = javaMethod('getInstance()','net.haesleinhuepf.clatlab.CLATLAB')
%a3 = net.haesleinhuepf.clatlab.CLATLAB();
A = {a1, a2}


% import net.haesleinhuepf.clatlab.CLATLAB

clatlab =  net.haesleinhuepf.clatlab.CLATLAB.getInstance();

% check if it's running 
string(clatlab.getGPUName())

img = [1 2 3
       4 5 6]

clatlab.push(img)




