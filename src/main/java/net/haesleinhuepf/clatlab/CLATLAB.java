package net.haesleinhuepf.clatlab;

import ij.ImagePlus;
import net.haesleinhuepf.clij.CLIJ;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
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
    public final MOCL mocl;

    public CLATLAB() {
        this.clij = CLIJ.getInstance();
        this.clij2 = new CLIJ2(clij);
        op = clij2.op;
        mocl = new MOCL(clij2, clij);
    }

    private CLATLAB(CLIJ clij) {
        this.clij = clij;
        this.clij2 = new CLIJ2(clij);
        op = clij2.op;
        mocl = new MOCL(clij2, clij);
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

    @Deprecated
    public Object push(Object object) {
        return mocl.push(object).buffer;
    }

    public Object pull(ClearCLBuffer buffer) {
        return mocl.pull(buffer);
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
