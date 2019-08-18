package net.haesleinhuepf.clatlab.converters;

import net.haesleinhuepf.clatlab.helptypes.Byte3;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.converters.AbstractCLIJConverter;
import net.haesleinhuepf.clij.converters.CLIJConverterPlugin;
import org.scijava.plugin.Plugin;

import java.nio.ByteBuffer;

@Plugin(type = CLIJConverterPlugin.class)
public class ClearCLBufferToByte3Converter extends AbstractCLIJConverter<ClearCLBuffer, Byte3> {

    @Override
    public Byte3 convert(ClearCLBuffer source) {
        Byte3 target = new Byte3(new byte[(int)source.getDepth()][(int)source.getHeight()][(int)source.getWidth()]);
        byte[] array = new byte[(int)(source.getWidth() * source.getHeight() * source.getDepth())];

        ByteBuffer buffer = ByteBuffer.wrap(array);
        source.writeTo(buffer, true);

        int count = 0;
        for (int z = 0; z < target.data.length; z++) {
            for (int y = 0; y < target.data[0].length; y++) {
                for (int x = 0; x < target.data[0][0].length; x++) {
                    target.data[z][y][x] = array[count];
                    count++;
                }
            }
        }
        return target;
    }

    @Override
    public Class<Byte3> getTargetType() {
        return Byte3.class;
    }

    @Override
    public Class<ClearCLBuffer> getSourceType() {
        return ClearCLBuffer.class;
    }
}

