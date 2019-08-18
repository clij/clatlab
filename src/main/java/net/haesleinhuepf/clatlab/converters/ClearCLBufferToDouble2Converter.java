package net.haesleinhuepf.clatlab.converters;

import net.haesleinhuepf.clatlab.helptypes.Double2;
import net.haesleinhuepf.clatlab.helptypes.Double3;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.converters.AbstractCLIJConverter;
import net.haesleinhuepf.clij.converters.CLIJConverterPlugin;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import org.scijava.plugin.Plugin;

import java.nio.ByteBuffer;
import java.nio.FloatBuffer;

/**
 * Todo: Shall we deal with float images differently than with double images?
 */
@Plugin(type = CLIJConverterPlugin.class)
public class ClearCLBufferToDouble2Converter extends AbstractCLIJConverter<ClearCLBuffer, Double2> {

    @Override
    public Double2 convert(ClearCLBuffer source) {
        Double2 target = new Double2(new double[(int)source.getHeight()][(int)source.getWidth()]);
        float[] array = new float[(int)(source.getWidth() * source.getHeight())];

        FloatBuffer buffer = FloatBuffer.wrap(array);
        source.writeTo(buffer, true);

        int count = 0;
        for (int y = 0; y < target.data.length; y++) {
            for (int x = 0; x < target.data[0].length; x++) {
                target.data[y][x] = array[count];
                count++;
            }
        }
        return target;
    }

    @Override
    public Class<Double2> getTargetType() {
        return Double2.class;
    }

    @Override
    public Class<ClearCLBuffer> getSourceType() {
        return ClearCLBuffer.class;
    }
}

