package net.haesleinhuepf.clatlab;

import net.haesleinhuepf.clatlab.converters.*;
import net.haesleinhuepf.clatlab.helptypes.Byte2;
import net.haesleinhuepf.clatlab.helptypes.Byte3;
import net.haesleinhuepf.clatlab.helptypes.Double2;
import net.haesleinhuepf.clatlab.helptypes.Double3;
import net.haesleinhuepf.clij.CLIJ;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import net.haesleinhuepf.clij.utilities.CLIJOps;

/**
 * The CLATLAB gateway.
 *
 * Author: haesleinhuepf
 *         August 2019
 */
public class CLATLAB {


    private static CLATLAB instance;
    private final CLIJ clij;

    public CLATLAB() {
        this.clij = CLIJ.getInstance();
    }

    private CLATLAB(CLIJ clij) {
        this.clij = clij;
    }

    public static CLATLAB getInstance() {
        if (instance == null) {
            instance = new CLATLAB(CLIJ.getInstance());
        }
        return instance;
    }

    public CLATLAB getInstance(String id) {
        if (instance == null) {
            instance = new CLATLAB(CLIJ.getInstance(id));
        }
        return instance;
    }

    public Object push(Object object) {
        if (object instanceof double[][][]) {
            Double3 double3 = new Double3((double[][][])object);
            Double3ToClearCLBufferConverter converter = new Double3ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return converter.convert(double3);
        }
        if (object instanceof double[][]) {
            Double2 double2 = new Double2((double[][])object);
            Double2ToClearCLBufferConverter converter = new Double2ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return converter.convert(double2);
        }
        if (object instanceof byte[][][]) {
            Byte3 byte3 = new Byte3((byte[][][])object);
            Byte3ToClearCLBufferConverter converter = new Byte3ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return converter.convert(byte3);
        }
        if (object instanceof byte[][]) {
            Byte2 byte2 = new Byte2((byte[][])object);
            Byte2ToClearCLBufferConverter converter = new Byte2ToClearCLBufferConverter();
            converter.setCLIJ(clij);
            return converter.convert(byte2);
        }
        throw new IllegalArgumentException("Conversion of " + object +
                " / " + object.getClass().getName() + " not supported");
    }

    public Object pull(ClearCLBuffer buffer) {
        if (buffer.getNativeType() == NativeTypeEnum.UnsignedByte) {
            if (buffer.getDimension() == 2) {
                return new ClearCLBufferToByte2Converter().convert(buffer).data;
            }
            if (buffer.getDimension() == 3) {
                return new ClearCLBufferToByte3Converter().convert(buffer).data;
            }
        }
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

    public ClearCLBuffer create(long[] dimensions, NativeTypeEnum type) {
        return clij.create(dimensions, type);
    }

    public ClearCLBuffer create(ClearCLBuffer buffer) {
        return clij.create(buffer);
    }

    public CLIJOps op() {
        return clij.op();
    }

    public String getGPUName() {
        return clij.getGPUName();
    }
}
