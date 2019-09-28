package net.haesleinhuepf.clatlab;

import ij.IJ;
import ij.ImagePlus;
import net.haesleinhuepf.clatlab.converters.*;
import net.haesleinhuepf.clatlab.helptypes.*;
import net.haesleinhuepf.clij.CLIJ;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import net.haesleinhuepf.clijx.CLIJx;

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

    CLIJx clijx;
    MOCL(CLIJx clijx, CLIJ clij) {
        this.clijx = clijx;
        this.clij = clij;
    }


    public MOCLBuffer imhist(MOCLBuffer input, int numberOfBins) {
        float minimumGreyValue = (new Double(clijx.op.minimumOfAllPixels(input.buffer))).floatValue();
        float maximumGreyValue = (new Double(clijx.op.maximumOfAllPixels(input.buffer))).floatValue();

        ClearCLBuffer histogram = clijx.create(new long[]{(long)numberOfBins, 1L, 1L}, NativeTypeEnum.Float);
        clijx.op.fillHistogram(input.buffer, histogram, minimumGreyValue, maximumGreyValue);

        return new MOCLBuffer(this, histogram);
    }

    public MOCLBuffer fliplr(MOCLBuffer input) {
        ClearCLBuffer output = clijx.create(input.buffer);
        if (input.buffer.getDimension() == 2) {
            clijx.op.flip(input.buffer, output, true, false);
        } else {
            clijx.op.flip(input.buffer, output, true, false, false);
        }
        return new MOCLBuffer(this, output);
    }

    public MOCLBuffer imRead(String imageFile) {
        ImagePlus imp = IJ.openImage(imageFile);
        return new MOCLBuffer(this, clijx.convert(imp, ClearCLBuffer.class));
    }

    public double min(MOCLBuffer input) {
        return clijx.op.minimumOfAllPixels(input.buffer);
    }

    public double max(MOCLBuffer input) {
        return clijx.op.maximumOfAllPixels(input.buffer);
    }

    public double mean(MOCLBuffer input) {
        return clijx.op.sumPixels(input.buffer) / input.buffer.getWidth() / input.buffer.getHeight() / input.buffer.getDepth();
    }

    public MOCLBuffer ones(int numberOfElementsX) {
        ClearCLBuffer buffer = anys(numberOfElementsX).buffer;
        clijx.op.set(buffer, 1f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer ones(int numberOfElementsX, int numberOfElementsY) {
        ClearCLBuffer buffer = anys(numberOfElementsX, numberOfElementsY).buffer;
        clijx.op.set(buffer, 1f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer ones(int numberOfElementsX, int numberOfElementsY, int numberOfElementsZ) {
        ClearCLBuffer buffer = anys(numberOfElementsX, numberOfElementsY, numberOfElementsZ).buffer;
        clijx.op.set(buffer, 1f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer zeros(int numberOfElements) {
        ClearCLBuffer buffer = anys(numberOfElements).buffer;
        clijx.op.set(buffer, 0f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer zeros(int numberOfElementsX, int numberOfElementsY) {
        ClearCLBuffer buffer = anys(numberOfElementsX, numberOfElementsY).buffer;
        clijx.op.set(buffer, 0f);
        return new MOCLBuffer(this, buffer);
    }

    public MOCLBuffer zeros(int numberOfElementsX, int numberOfElementsY, int numberOfElementsZ) {
        ClearCLBuffer buffer = anys(numberOfElementsX, numberOfElementsY, numberOfElementsZ).buffer;
        clijx.op.set(buffer, 0f);
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
        return new MOCLBuffer(this, clijx.create(dimensions, NativeTypeEnum.Float));
    }

    public long[] size(MOCLBuffer input) {
        return clijx.op.getSize(input.buffer);
    }

    public MOCLBuffer colon(int min, int max) {
        System.out.println("MOCL colon2");
        ClearCLBuffer intensities = clijx.create(new long[]{max-min + 1, 1}, NativeTypeEnum.Float);
        ClearCLBuffer temp = clijx.create(intensities);
        clijx.op.set(intensities, 1f);
        clijx.op.multiplyImageAndCoordinate(intensities, temp, 0);
        clijx.op.addImageAndScalar(temp, intensities, new Float(min));
        temp.close();
        return new MOCLBuffer(this, intensities);
    }

    public MOCLBuffer colon(int min, int step, int max) {
        System.out.println("MOCL colon3");
        ClearCLBuffer intensities = clijx.create(new long[]{(max-min)/step + 1, 1}, NativeTypeEnum.Float);
        ClearCLBuffer temp = clijx.create(intensities);
        clijx.op.set(intensities, 1f);
        clijx.op.multiplyImageAndCoordinate(intensities, temp, 0);
        clijx.op.multiplyImageAndScalar(temp, intensities, new Float(step));
        clijx.op.addImageAndScalar(intensities, temp, new Float(min));
        intensities.close();
        return new MOCLBuffer(this, temp);
    }

    public MOCLBuffer push(Object object) {
        if (object instanceof MOCLBuffer) {
            return (MOCLBuffer)object;
        }
        if (object instanceof double[][][]) {
            Double3 double3 = new Double3((double[][][])object);
            System.out.println("d3 size: " + double3.data.length + "/" + double3.data[0].length + "/" + double3.data[0][0].length );
            Double3ToClearCLBufferConverter converter = new Double3ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(double3));
        }
        if (object instanceof double[][]) {
            Double2 double2 = new Double2((double[][])object);
            System.out.println("d2 size: " + double2.data.length + "/" + double2.data[0].length );
            Double2ToClearCLBufferConverter converter = new Double2ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(double2));
        }
        if (object instanceof double[]) {
            Double1 double1 = new Double1((double[])object);
            System.out.println("d1 size: " + double1.data.length );
            Double1ToClearCLBufferConverter converter = new Double1ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(double1));
        }
        if (object instanceof byte[][][]) {
            Byte3 byte3 = new Byte3((byte[][][])object);
            System.out.println("b3 size: " + byte3.data.length + "/" + byte3.data[0].length + "/" + byte3.data[0][0].length );
            Byte3ToClearCLBufferConverter converter = new Byte3ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(byte3));
        }
        if (object instanceof byte[][]) {
            Byte2 byte2 = new Byte2((byte[][])object);
            System.out.println("b2 size: " + byte2.data.length + "/" + byte2.data[0].length );
            Byte2ToClearCLBufferConverter converter = new Byte2ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(byte2));
        }
        if (object instanceof byte[]) {
            Byte1 byte1 = new Byte1((byte[])object);
            System.out.println("b1 size: " + byte1.data.length);
            Byte1ToClearCLBufferConverter converter = new Byte1ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return new MOCLBuffer(this, converter.convert(byte1));
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
