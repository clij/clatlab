package net.haesleinhuepf.clatlab;

import ij.ImagePlus;
import net.haesleinhuepf.clij.CLIJ;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import net.haesleinhuepf.clij2.CLIJ2;

/**
 * The CLATLAB gateway.
 *
 * Author: haesleinhuepf
 *         August 2019
 */
public class CLATLAB extends CLIJ2 {
    private static CLATLAB instance;
    public final MOCL mocl;

    public CLATLAB() {
        super(CLIJ.getInstance());
        mocl = new MOCL(this, getCLIJ());
    }

    private CLATLAB(CLIJ clij) {
        super(clij);
        mocl = new MOCL(this, getCLIJ());
    }

    public static CLATLAB getInstance() {
        if (instance == null) {
            instance = new CLATLAB(CLIJ.getInstance());
        }
        return instance;
    }
}
