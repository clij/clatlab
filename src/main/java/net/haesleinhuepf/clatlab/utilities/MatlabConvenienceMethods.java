package net.haesleinhuepf.clatlab.utilities;

import net.haesleinhuepf.clij.CLIJ;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.kernels.Kernels;
import net.haesleinhuepf.clij.matrix.TransposeXY;

/**
 * MatlabConvenienceMethods
 * <p>
 * <p>
 * <p>
 * Author: @haesleinhuepf
 * 08 2019
 */
public class MatlabConvenienceMethods {
    private CLIJ clij;
    public MatlabConvenienceMethods(CLIJ clij) {
        this.clij = clij;
    }
    public boolean apostophe(ClearCLBuffer bufferin, ClearCLBuffer bufferout) {
        return TransposeXY.transposeXY(clij, bufferin, bufferout);
    }

    public boolean plus(ClearCLBuffer bufferin1, ClearCLBuffer bufferout, double scalar) {
        return Kernels.addImageAndScalar(clij, bufferin1, bufferout, new Float(scalar));
    }

    public boolean star(ClearCLBuffer bufferin1, ClearCLBuffer bufferout, double scalar) {
        return Kernels.multiplyImageAndScalar(clij, bufferin1, bufferout, new Float(scalar));
    }

    public boolean dotPlus(ClearCLBuffer bufferin1, ClearCLBuffer bufferin2, ClearCLBuffer bufferout) {
        return Kernels.addImages(clij, bufferin1, bufferin2, bufferout);
    }

    public boolean dotStar(ClearCLBuffer bufferin1, ClearCLBuffer bufferin2, ClearCLBuffer bufferout) {
        return Kernels.multiplyImages(clij, bufferin1, bufferin2, bufferout);
    }
}
