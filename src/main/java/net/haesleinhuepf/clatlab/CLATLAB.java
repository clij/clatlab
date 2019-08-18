package net.haesleinhuepf.clatlab;

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

    public String push(Object object) {
        if (object instanceof double[][][]) {
            return "double[][][]";
        }
        if (object instanceof double[][]) {
            return "double[][]";
        }
        if (object instanceof double[]) {
            return "double[]";
        }
        if (object instanceof Double) {
            return "Double";
        }
        return ("" + object + "\n" +
                "" + object.getClass().getName());
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
