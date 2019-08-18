# clatlab
 
clatlab is a bridge between [Matlab](https://de.mathworks.com/products/matlab.html) and [clij](https://clij.github.io/).

![Image](images/clablab-screenshot.png)

Right now, this is very preliminary.

## Installation
Download the following files, removed the numbers from their file endings and put them all in a folder:
* [clatlab-0.1.0.jar](https://github.com/clij/clatlab/releases/download/0.1.0/clatlab-0.1.0.jar)
* [bridj-0.7.0.jar](https://sites.imagej.net/clij/jars/bridj-0.7.0.jar-20181201213334)
* [clij_1.1.4.jar](https://github.com/clij/clij/releases/download/1.1.4/clij_-1.1.4.jar)
* [clij-clearcl-0.8.4.jar](https://github.com/clij/clij/releases/download/1.1.3/clij-clearcl-0.8.4.jar)
* [clij-core-1.1.4.jar](https://github.com/clij/clij/releases/download/1.1.4/clij-core-1.1.4.jar)
* [clij-coremem-0.5.5.jar](https://github.com/clij/clij/releases/download/1.1.3/clij-coremem-0.5.5.jar)
* [clij-legacy_-0.1.0.jar](https://github.com/clij/clij-legacy/releases/download/0.1.0/clij-legacy_-0.1.0.jar)
* [imagej-common-0.28.2.jar](https://sites.imagej.net/Java-8/jars/imagej-common-0.28.2.jar-20190516211613)
* [imglib2-5.6.3.jar](https://sites.imagej.net/Java-8/jars/imglib2-5.6.3.jar-20181204141527)
* [imglib2-realtransform-2.1.0.jar](https://sites.imagej.net/Java-8/jars/imglib2-realtransform-2.1.0.jar-20181204141527)
* [jocl-2.0.1.jar](https://sites.imagej.net/clij/jars/jocl-2.0.1.jar-20181201212910)
* [scijava-common-2.77.0.jar](https://sites.imagej.net/Java-8/jars/scijava-common-2.76.1.jar-20181204141527)

In your matlab script, specify _every_ individual jar file in this folder using `javaaddpath('folder/jarfile.jar').

## Example code 
Examples are available in the [matlab](https://github.com/clij/clatlab/blob/master/src/main/matlab/) folder. 

## Please note
It is recommended to [use clij from Fiji](https://clij.github.io/clij-docs/installationInFiji). 
Matlab support is under development.

[Back to CLIJ documentation](https://clij.github.io/)
