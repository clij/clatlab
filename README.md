# clatlab
 
clatlab is a bridge between [Matlab](https://de.mathworks.com/products/matlab.html) and [clij](https://clij.github.io/).

![Image](images/clablab-screenshot.png)

Right now, this is very preliminary.

## Installation
Download the following files, removed the numbers from their file endings and put them all in the `<HOME_DIR>/Documents/MATLAB folder:
* [clatlab-0.6.0-jar-with-dependencies.jar](https://github.com/clij/clatlab/releases/download/0.6.0/clatlab-0.6.0-jar-with-dependencies.jar)
* [init_clatlab.m](https://github.com/clij/clatlab/blob/master/src/main/matlab/init_clatlab.m)

Test the installation by executing this script from matlab:
```
clijx = init_clatlab();
% print out name of used GPU:
clijx.getGPUName()
```

## Example code
Examples are available in the [matlab](https://github.com/clij/clatlab/blob/master/src/main/matlab/) folder. 
 
Clatlab provides two entry points for processing:
* `clijx` is the entry point to clijs image processing operations. Read the [clij reference](https://clij.github.io/clij-docs/referenceJython) to see which operations are available. Replace `clij.op().` with `clijx` in order to make it run in matlab. For example a Gaussian blur can be applied like this:

```
clijx.op.blur(imageIn, imageOut, Float(5), Float(5));
```

* `clijx.mocl` contains functionality which is accessible in a matlab way, but they are running using clij and OpenCL on the GPU. You can replace matlab code by mocl code:

```matlab
% matlab code:
a = ones(10, 1) * 6 + 8;
b = ones(10, 1) * 67 + 6;
c = a + b

% mocl alternative:
A = mocl.ones(10, 1) * 6 + 8;
B = mocl.ones(10, 1) * 67 + 6;
C = A + B;
c = mocl.pull(C);
```


### MOCL Commands
Following MOCL commands are implemented. Some are not fully tested yet. Work in progress.

| Command         | Matlab expresson     | mocl expression      | clij/clatlab counter part                       |
| --------------- | -------------------- | -------------------- | ----------------------------------------------- |
| push(a)         |                      | c = mocl.push(a)     | c = clijx.pushMat(a);                               |
| pull(a)         |                      | c = mocl.pull(a)     | c = clijx.pullMat(a);                               |
| plus(a,b)       | c = a + b            | c = a + b            | clijx.addImages(a, b, c);                   |
| minus(a,b)      | c = a - b            | c = a - b            | clijx.subtractImages(a, b, c);              |
| uminus(a)       | c = -a               | c = -a               | clijx.invert(a, c);                         |
| transpose(a)    | c = a.'              | c = a.'              | clijx.transposeXY(a, c);                     |
| times(a,b)      | c = a .* b           | c = a .* b           | clijx.multiplyImages(a, b, c);              |
| mtimes(a,b)     | c = a * b            | c = a * b            | clijx.multiplyMatrix(a, b, c);               |
| rdivide(a,b)    | c = a ./ b           | c = a ./ b           | clijx.divideImages(a, b, c);                |
| ldivide(a,b)    | c = b ./ b           | c = b ./ b           | clijx.divideImages(b, a, c);                |
| power(a,b)      | c = a .^ b           | c = a .^ b           | clijx.powerImages(a, b, c);                  |
| lt(a,b)         | c = a < b            | c = a < b            | clijx.smaller(a, b, c);                      |
| gt(a,b)         | c = a > b            | c = a > b            | clijx.greater(a, b, c);                      |
| le(a,b)         | c = a <= b           | c = a <= b           | clijx.smallerOrEqual(a, b, c);               |
| ge(a,b)         | c = a >= b           | c = a >= b           | clijx.greaterOrEqual(a, b, c);               |
| ne(a,b)         | c = a ~= b           | c = a ~= b           | clijx.notEqual(a, b, c);                     |
| eq(a,b)         | c = a == b           | c = a == b           | clijx.equal(a, b, c);                        |
| and(a,b)        | c = a & b            | c = a & b            | clijx.binaryAnd(a, b, c);                   |
| or(a,b)         | c = a &#x49; b            | c = a &#x49; b            | clij.op().binaryOr(a, b, c);                    |
| not(a)          | c = ~b               | c = ~b               | clijx.binaryNot(a, c);                      |
| imhist(a)       | [c,x] = imhist(a)    | c = mocl.imhist(a)   | clijx.fillHistogram(a, c);                  |
| fliplr(a)       | c = fliplr(a)        | c = mocl.fliplr(a)   | clijx.flip(a, c, true, false, false);       |
| imRead(a)       | c = imread(a)        | c = imread(a)        |                                                 |
| min(a)          | c = min(a)           | c = mocl.min(a)      | c = clijx.minimumOfAllPixels(a);            |
| max(a)          | c = max(a)           | c = mocl.max(a)      | c = clijx.maximumOfAllPixels(a);            |
| mean(a)         | c = mean(a)          | c = mocl.mean(a)     | c = clijx.meanOfAllPixels(a);               |
| ones(a)         | c = ones(a)          | c = mocl.ones(a)     |                                                 |
| zeros(a)        | c = zeros(a)         | c = mocl.zeros(a)    |                                                 |
| size(a)         | c = size(a)          | c = mocl.size(a)     |                                                 |
| colon(a,b)      | c = [a:b]            | c = mocl.colon(a,b)  |                                                 |

## How to develop clatlab
Clone this repository and build it using maven. Afterwards, you find the `clatlab.jar` in the `target` directory. 
Copy it to your clatlab/matlab java classpath.

```bash
git clone https://github.com/clij/clatlab
cd clatlab
mvn package
cp target/clatlab*.jar classpath/
```


## Please note
It is recommended to [use clij from Fiji](https://clij.github.io/clij-docs/installationInFiji). 
Matlab support is under development.

[Back to CLIJ documentation](https://clij.github.io/)

[Imprint](https://clij.github.io/imprint)
