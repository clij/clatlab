package net.haesleinhuepf.clatlab;

import ij.IJ;
import ij.ImagePlus;
import net.haesleinhuepf.clatlab.converters.*;
import net.haesleinhuepf.clatlab.helptypes.Byte2;
import net.haesleinhuepf.clatlab.helptypes.Byte3;
import net.haesleinhuepf.clatlab.helptypes.Double2;
import net.haesleinhuepf.clatlab.helptypes.Double3;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import net.haesleinhuepf.clij2.CLIJ2;

/**
 * MOCL
 * <p>
 * <p>
 * <p>
 * Author: @haesleinhuepf
 * 08 2019
 */
public class MOCL {
    CLIJ2 clij2;
    MOCL(CLIJ2 clij2) {
        this.clij2 = clij2;
    }


    public MOCLBuffer imhist(MOCLBuffer input, int numberOfBins) {
        float minimumGreyValue = (new Double(clij2.op.minimumOfAllPixels(input.buffer))).floatValue();
        float maximumGreyValue = (new Double(clij2.op.maximumOfAllPixels(input.buffer))).floatValue();

        ClearCLBuffer histogram = clij2.create(new long[]{(long)numberOfBins, 1L, 1L}, NativeTypeEnum.Float);
        clij2.op.fillHistogram(input.buffer, histogram, minimumGreyValue, maximumGreyValue);

        return new MOCLBuffer(this, histogram);
    }

    public MOCLBuffer imRead(String imageFile) {
        ImagePlus imp = IJ.openImage(imageFile);
        return new MOCLBuffer(this, clij2.convert(imp, ClearCLBuffer.class));
    }

    public double min(MOCLBuffer input) {
        return clij2.op.minimumOfAllPixels(input.buffer);
    }

    public double max(MOCLBuffer input) {
        return clij2.op.maximumOfAllPixels(input.buffer);
    }

    public double mean(MOCLBuffer input) {
        return clij2.op.sumPixels(input.buffer) / input.buffer.getWidth() / input.buffer.getHeight() / input.buffer.getDepth();
    }

    public MOCLBuffer ones(int numberOfElementsX) {
        ClearCLBuffer buffer = anys(numberOfElementsX).buffer;
        clij2.op.set(buffer, 1f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer ones(int numberOfElementsX, int numberOfElementsY) {
        ClearCLBuffer buffer = anys(numberOfElementsY, numberOfElementsX).buffer;
        clij2.op.set(buffer, 1f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer ones(int numberOfElementsX, int numberOfElementsY, int numberOfElementsZ) {
        ClearCLBuffer buffer = anys(numberOfElementsZ, numberOfElementsY, numberOfElementsX).buffer;
        clij2.op.set(buffer, 1f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer zeros(int numberOfElements) {
        ClearCLBuffer buffer = anys(numberOfElements).buffer;
        clij2.op.set(buffer, 0f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer zeros(int numberOfElementsX, int numberOfElementsY) {
        ClearCLBuffer buffer = anys(numberOfElementsY, numberOfElementsX).buffer;
        clij2.op.set(buffer, 0f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer zeros(int numberOfElementsX, int numberOfElementsY, int numberOfElementsZ) {
        ClearCLBuffer buffer = anys(numberOfElementsZ, numberOfElementsY, numberOfElementsX).buffer;
        clij2.op.set(buffer, 0f);
        return new MOCLBuffer(this, buffer);
    }


    public MOCLBuffer anys(int... numberOfElements) {
        long[] dimensions = new long[Math.max(Math.min(numberOfElements.length, 3), 2)];
        for (int i = 0; i < dimensions.length; i++) {
            if (i < numberOfElements.length) {
                dimensions[i] = numberOfElements[i];
            } else {
                dimensions[i] = dimensions[0];
            }
        }
        return new MOCLBuffer(this, clij2.create(dimensions, NativeTypeEnum.Float));
    }

    public long[] size(MOCLBuffer input) {
        return clij2.op.getSize(input.buffer);
    }

    public Object mat(MOCLBuffer input) {
        return mat(input.buffer);
    }
    public Object mat(ClearCLBuffer buffer) {
        if (buffer.getNativeType() == NativeTypeEnum.Float) {
            if (buffer.getDimension() == 2) {
                return new ClearCLBufferToDouble2Converter().convert(buffer).data;
            }
            if (buffer.getDimension() == 3) {
                return new ClearCLBufferToDouble3Converter().convert(buffer).data;
            }
        }

        throw new IllegalArgumentException("Conversion of " + buffer +
                " / " + buffer.getClass().getName() + " not supported");
    }
}
