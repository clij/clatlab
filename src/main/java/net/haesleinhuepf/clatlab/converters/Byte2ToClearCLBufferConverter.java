package net.haesleinhuepf.clatlab.converters;

import net.haesleinhuepf.clatlab.helptypes.Byte2;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.converters.AbstractCLIJConverter;
import net.haesleinhuepf.clij.converters.CLIJConverterPlugin;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import org.scijava.plugin.Plugin;

import java.nio.ByteBuffer;

@Plugin(type = CLIJConverterPlugin.class)
public class Byte2ToClearCLBufferConverter extends AbstractCLIJConverter<Byte2, ClearCLBuffer> {

    @Override
    public ClearCLBuffer convert(Byte2 source) {
        long[] dimensions = new long[]{
                source.data[0].length,
                source.data.length
        };

        int numberOfPixelsPerSlice = (int)(dimensions[0] * dimensions[1]);
        long numberOfPixels = numberOfPixelsPerSlice;


        ClearCLBuffer target = clij.createCLBuffer(dimensions, NativeTypeEnum.UnsignedByte);
        byte[] inputArray = new byte[(int)numberOfPixels];

        int count = 0;
        for (int y = 0; y < dimensions[1]; y++) {
            for (int x = 0; x < dimensions[0]; x++) {
                inputArray[count] = source.data[y][x];
                count++;
            }
        }
        ByteBuffer byteBuffer = ByteBuffer.wrap(inputArray);
        target.readFrom(byteBuffer, true);
        return target;
    }

    @Override
    public Class<Byte2> getSourceType() {
        return Byte2.class;
    }

    @Override
    public Class<ClearCLBuffer> getTargetType() {
        return ClearCLBuffer.class;
    }
}

