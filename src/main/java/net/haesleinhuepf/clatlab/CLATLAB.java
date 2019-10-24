package net.haesleinhuepf.clatlab;

import ij.ImagePlus;
import net.haesleinhuepf.clij.CLIJ;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import net.haesleinhuepf.clijx.CLIJx;
import net.haesleinhuepf.clijx.utilities.CLIJxOps;

/**
 * The CLATLAB gateway.
 *
 * Author: haesleinhuepf
 *         August 2019
 */
public class CLATLAB extends CLIJx {
    private static CLATLAB instance;
    public final MOCL mocl;

    public CLATLAB() {
        super(CLIJ.getInstance());
        mocl = new MOCL(clijx, clij);
    }

    private CLATLAB(CLIJ clij) {
        super(clij);
        mocl = new MOCL(clijx, clij);
    }

    public static CLATLAB getInstance() {
        if (instance == null) {
            instance = new CLATLAB(CLIJ.getInstance());
        }
        return instance;
    }

    public Object pushMat(Object object) {
        return mocl.push(object).buffer;
    }

    public Object pullMat(ClearCLBuffer buffer) {
        return mocl.pull(buffer);
    }

    public void show(Object object, String headline) {
        ImagePlus imp = clij.convert(object, ImagePlus.class);
        imp.setTitle(headline);
        imp.show();
    }
}
