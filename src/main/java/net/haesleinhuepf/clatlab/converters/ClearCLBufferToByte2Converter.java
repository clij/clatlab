package net.haesleinhuepf.clatlab.converters;

import net.haesleinhuepf.clatlab.helptypes.Byte2;
import net.haesleinhuepf.clatlab.helptypes.Double2;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.converters.AbstractCLIJConverter;
import net.haesleinhuepf.clij.converters.CLIJConverterPlugin;
import org.scijava.plugin.Plugin;

import java.nio.ByteBuffer;
import java.nio.FloatBuffer;

@Plugin(type = CLIJConverterPlugin.class)
public class ClearCLBufferToByte2Converter extends AbstractCLIJConverter<ClearCLBuffer, Byte2> {

    @Override
    public Byte2 convert(ClearCLBuffer source) {
        Byte2 target = new Byte2(new byte[(int)source.getHeight()][(int)source.getWidth()]);
        byte[] array = new byte[(int)(source.getWidth() * source.getHeight())];

        ByteBuffer buffer = ByteBuffer.wrap(array);
        source.writeTo(buffer, true);

        int count = 0;
        for (int y = 0; y < target.data.length; y++) {
            // todo: use system.arraycopy instread of this:
            for (int x = 0; x < target.data[0].length; x++) {
                target.data[y][x] = array[count];
                count++;
            }
        }
        return target;
    }

    @Override
    public Class<Byte2> getTargetType() {
        return Byte2.class;
    }

    @Override
    public Class<ClearCLBuffer> getSourceType() {
        return ClearCLBuffer.class;
    }
}

