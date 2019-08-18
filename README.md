# clatlab
 
clatlab is a bridge between [Matlab](https://de.mathworks.com/products/matlab.html) and [clij](https://clij.github.io/).

![Image](images/clablab-screenshot.png)

Right now, this is very preliminary.

## Installation
Clone this repository.

```
git clone https://github.com/clij/clatlab
```

Build it using maven.

```
cd clatlab
mvn package
```

Open Matlab and navigate to the folder `<clatlab>/src/main/matlab` and open the `simpleworkflow.m` [example](https://github.com/clij/clatlab/blob/master/src/main/matlab/simplePipeline.m). 
CLATLAB will only work from this folder for the moment.

## Please note
It is recommended to [use clij from Fiji](https://clij.github.io/clij-docs/installationInFiji). 
Matlab support is under development.

[Back to CLIJ documentation](https://clij.github.io/)
