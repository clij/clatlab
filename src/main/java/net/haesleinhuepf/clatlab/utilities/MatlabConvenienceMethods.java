package net.haesleinhuepf.clatlab.utilities;

import ij.IJ;
import ij.ImagePlus;
import net.haesleinhuepf.clij.CLIJ;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import net.haesleinhuepf.clij.kernels.Kernels;
import net.haesleinhuepf.clij.matrix.TransposeXY;
import net.haesleinhuepf.clij2.CLIJ2;

/**
 * MatlabConvenienceMethods
 * <p>
 * <p>
 * <p>
 * Author: @haesleinhuepf
 * 08 2019
 */
public class MatlabConvenienceMethods {
    private CLIJ2 clij2;
    public MatlabConvenienceMethods(CLIJ2 clij2) {
        this.clij2 = clij2;
    }
    public ClearCLBuffer apostophe(ClearCLBuffer input) {
        ClearCLBuffer output;
        if (input.getDimension() == 2) {
            output = clij2.create(new long[]{input.getHeight(), input.getWidth()}, input.getNativeType());
        } else {
            output = clij2.create(new long[]{input.getHeight(), input.getWidth(), input.getDepth()}, input.getNativeType());
        }
        clij2.op.transposeXY(input, output);
        return output;
    }

    public ClearCLBuffer plus(ClearCLBuffer input, double scalar) {
        ClearCLBuffer output = clij2.create(input);
        clij2.op.addImageAndScalar(input, output, new Float(scalar));
        return output;
    }

    public ClearCLBuffer star(ClearCLBuffer input, double scalar) {
        ClearCLBuffer output = clij2.create(input);
        clij2.op.multiplyImageAndScalar(input, output, new Float(scalar));
        return output;
    }

    public ClearCLBuffer plus(ClearCLBuffer bufferin1, ClearCLBuffer bufferin2) {
        ClearCLBuffer output = clij2.create(bufferin1);
        clij2.op.addImages(bufferin1, bufferin2, output);
        return output;
    }

    public ClearCLBuffer dotStar(ClearCLBuffer bufferin1, ClearCLBuffer bufferin2) {
        ClearCLBuffer output = clij2.create(bufferin1);
        clij2.op.multiplyImages(bufferin1, bufferin2, output);
        return output;
    }

    public ClearCLBuffer imhist(ClearCLBuffer buffer, int numberOfBins) {
        float minimumGreyValue = (new Double(clij2.op.minimumOfAllPixels(buffer))).floatValue();
        float maximumGreyValue = (new Double(clij2.op.maximumOfAllPixels(buffer))).floatValue();

        ClearCLBuffer histogram = clij2.create(new long[]{(long)numberOfBins, 1L, 1L}, NativeTypeEnum.Float);
        clij2.op.fillHistogram(buffer, histogram, minimumGreyValue, maximumGreyValue);

        return histogram;
    }

    public ClearCLBuffer[] imRead(String imageFile) {
        ImagePlus imp = IJ.openImage(imageFile);
        return new ClearCLBuffer[] {clij2.convert(imp, ClearCLBuffer.class)};
    }

    public double min(ClearCLBuffer input) {
        return clij2.op.minimumOfAllPixels(input);
    }

    public double max(ClearCLBuffer input) {
        return clij2.op.maximumOfAllPixels(input);
    }

    public double mean(ClearCLBuffer input) {
        return clij2.op.sumPixels(input) / input.getWidth() / input.getHeight() / input.getDepth();
    }

    public ClearCLBuffer ones(int numberOfElementsX) {
        ClearCLBuffer buffer = anys(numberOfElementsX);
        clij2.op.set(buffer, 1f);
        return buffer;
    }

    public ClearCLBuffer ones(int numberOfElementsX, int numberOfElementsY) {
        ClearCLBuffer buffer = anys(numberOfElementsY, numberOfElementsX);
        clij2.op.set(buffer, 1f);
        return buffer;
    }

    public ClearCLBuffer ones(int numberOfElementsX, int numberOfElementsY, int numberOfElementsZ) {
        ClearCLBuffer buffer = anys(numberOfElementsZ, numberOfElementsY, numberOfElementsX);
        clij2.op.set(buffer, 1f);
        return buffer;
    }

    public ClearCLBuffer zeros(int numberOfElements) {
        ClearCLBuffer buffer = anys(numberOfElements);
        clij2.op.set(buffer, 0f);
        return buffer;
    }

    public ClearCLBuffer zeros(int numberOfElementsX, int numberOfElementsY) {
        ClearCLBuffer buffer = anys(numberOfElementsY, numberOfElementsX);
        clij2.op.set(buffer, 0f);
        return buffer;
    }

    public ClearCLBuffer zeros(int numberOfElementsX, int numberOfElementsY, int numberOfElementsZ) {
        ClearCLBuffer buffer = anys(numberOfElementsZ, numberOfElementsY, numberOfElementsX);
        clij2.op.set(buffer, 0f);
        return buffer;
    }

    public ClearCLBuffer colon(int min, int max) {
        ClearCLBuffer intensities = clij2.create(new long[]{max-min + 1, 1}, NativeTypeEnum.Float);
        ClearCLBuffer temp = clij2.create(intensities);
        clij2.op.set(intensities, 1f);
        clij2.op.multiplyImageAndCoordinate(intensities, temp, 0);
        clij2.op.addImageAndScalar(temp, intensities, new Float(min));
        temp.close();
        return intensities;
    }

    public ClearCLBuffer colonColon(int min, int step, int max) {
        ClearCLBuffer intensities = clij2.create(new long[]{(max-min)/step + 1, 1}, NativeTypeEnum.Float);
        ClearCLBuffer temp = clij2.create(intensities);
        clij2.op.set(intensities, 1f);
        clij2.op.multiplyImageAndCoordinate(intensities, temp, 0);
        clij2.op.multiplyImageAndScalar(temp, intensities, new Float(step));
        clij2.op.addImageAndScalar(intensities, temp, new Float(min));
        intensities.close();
        return temp;
    }

    public ClearCLBuffer anys(int... numberOfElements) {
        long[] dimensions = new long[Math.max(Math.min(numberOfElements.length, 3), 2)];
        for (int i = 0; i < dimensions.length; i++) {
            if (i < numberOfElements.length) {
                dimensions[i] = numberOfElements[i];
            } else {
                dimensions[i] = dimensions[0];
            }
        }
        return clij2.create(dimensions, NativeTypeEnum.Float);
    }

    public long[] size(ClearCLBuffer buffer) {
        return clij2.op.getSize(buffer);
    }
}
