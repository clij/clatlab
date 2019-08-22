package net.haesleinhuepf.clatlab;

import ij.ImagePlus;
import net.haesleinhuepf.clatlab.converters.*;
import net.haesleinhuepf.clatlab.helptypes.Byte2;
import net.haesleinhuepf.clatlab.helptypes.Byte3;
import net.haesleinhuepf.clatlab.helptypes.Double2;
import net.haesleinhuepf.clatlab.helptypes.Double3;
import net.haesleinhuepf.clatlab.utilities.MatlabConvenienceMethods;
import net.haesleinhuepf.clij.CLIJ;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import net.haesleinhuepf.clij.utilities.CLIJOps;
import net.haesleinhuepf.clij2.CLIJ2;
import net.haesleinhuepf.clij2.utilities.CLIJ2Ops;

/**
 * The CLATLAB gateway.
 *
 * Author: haesleinhuepf
 *         August 2019
 */
public class CLATLAB {


    private static CLATLAB instance;
    private static CLIJ2 clij2;
    private final CLIJ clij;

    public final CLIJ2Ops op;
    public final MatlabConvenienceMethods m;

    public CLATLAB() {
        this.clij = CLIJ.getInstance();
        this.clij2 = new CLIJ2(clij);
        op = clij2.op;
        m = new MatlabConvenienceMethods(clij);
    }

    private CLATLAB(CLIJ clij) {
        this.clij = clij;
        this.clij2 = new CLIJ2(clij);
        op = clij2.op;
        m = new MatlabConvenienceMethods(clij);
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


    public ClearCLBuffer create(long[] dimensions) {
        return clij.create(dimensions, NativeTypeEnum.Float);
    }

    public ClearCLBuffer create(ClearCLBuffer buffer) {
        return clij.create(buffer);
    }

    /*
    * Deprecated: Use op without brackets instead
    */
    @Deprecated
    public CLIJ2Ops op() {
        return clij2.op;
    }

    public String getGPUName() {
        return clij.getGPUName();
    }

    public void show(Object object, String headline) {
        ImagePlus imp = clij.convert(object, ImagePlus.class);
        imp.setTitle(headline);
        imp.show();
    }
}
