package net.haesleinhuepf.clatlab;

import ij.IJ;
import ij.ImagePlus;
import net.haesleinhuepf.clatlab.converters.*;
import net.haesleinhuepf.clatlab.helptypes.Byte2;
import net.haesleinhuepf.clatlab.helptypes.Byte3;
import net.haesleinhuepf.clatlab.helptypes.Double2;
import net.haesleinhuepf.clatlab.helptypes.Double3;
import net.haesleinhuepf.clij.CLIJ;
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
    @Deprecated // use clij2 instead
    CLIJ clij;

    CLIJ2 clij2;
    MOCL(CLIJ2 clij2, CLIJ clij) {
        this.clij2 = clij2;
        this.clij = clij;
    }


    public MOCLBuffer imhist(MOCLBuffer input, int numberOfBins) {
        float minimumGreyValue = (new Double(clij2.op.minimumOfAllPixels(input.buffer))).floatValue();
        float maximumGreyValue = (new Double(clij2.op.maximumOfAllPixels(input.buffer))).floatValue();

        ClearCLBuffer histogram = clij2.create(new long[]{(long)numberOfBins, 1L, 1L}, NativeTypeEnum.Float);
        clij2.op.fillHistogram(input.buffer, histogram, minimumGreyValue, maximumGreyValue);

        return new MOCLBuffer(this, histogram);
    }

    public MOCLBuffer fliplr(MOCLBuffer input) {
        ClearCLBuffer output = clij2.create(input.buffer);
        if (input.buffer.getDimension() == 2) {
            clij2.op.flip(input.buffer, output, true, false);
        } else {
            clij2.op.flip(input.buffer, output, true, false, false);
        }
        return new MOCLBuffer(this, output);
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

    public MOCLBuffer colon(int min, int max) {
        System.out.println("MOCL colon2");
        ClearCLBuffer intensities = clij2.create(new long[]{max-min + 1, 1}, NativeTypeEnum.Float);
        ClearCLBuffer temp = clij2.create(intensities);
        clij2.op.set(intensities, 1f);
        clij2.op.multiplyImageAndCoordinate(intensities, temp, 0);
        clij2.op.addImageAndScalar(temp, intensities, new Float(min));
        temp.close();
        return new MOCLBuffer(this, intensities);
    }

    public MOCLBuffer colon(int min, int step, int max) {
        System.out.println("MOCL colon3");
        ClearCLBuffer intensities = clij2.create(new long[]{(max-min)/step + 1, 1}, NativeTypeEnum.Float);
        ClearCLBuffer temp = clij2.create(intensities);
        clij2.op.set(intensities, 1f);
        clij2.op.multiplyImageAndCoordinate(intensities, temp, 0);
        clij2.op.multiplyImageAndScalar(temp, intensities, new Float(step));
        clij2.op.addImageAndScalar(intensities, temp, new Float(min));
        intensities.close();
        return new MOCLBuffer(this, temp);
    }

    public MOCLBuffer push(Object object) {
        if (object instanceof double[][][]) {
            Double3 double3 = new Double3((double[][][])object);
            Double3ToClearCLBufferConverter converter = new Double3ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(double3));
        }
        if (object instanceof double[][]) {
            Double2 double2 = new Double2((double[][])object);
            Double2ToClearCLBufferConverter converter = new Double2ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(double2));
        }
        if (object instanceof double[]) {
            Double2 double2 = new Double2(new double[][]{(double[])object});
            Double2ToClearCLBufferConverter converter = new Double2ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(double2));
        }
        if (object instanceof byte[][][]) {
            Byte3 byte3 = new Byte3((byte[][][])object);
            Byte3ToClearCLBufferConverter converter = new Byte3ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(byte3));
        }
        if (object instanceof byte[][]) {
            Byte2 byte2 = new Byte2((byte[][])object);
            Byte2ToClearCLBufferConverter converter = new Byte2ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(byte2));
        }
        if (object instanceof byte[]) {
            Byte2 byte2 = new Byte2(new byte[][]{(byte[])object});
            Byte2ToClearCLBufferConverter converter = new Byte2ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(byte2));
        }
        throw new IllegalArgumentException("Conversion of " + object +
                " / " + object.getClass().getName() + " not supported");
    }

    public Object pull(MOCLBuffer input) {
        return pull(input.buffer);
    }
    public Object pull(ClearCLBuffer buffer) {
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
