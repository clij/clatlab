package net.haesleinhuepf.clicy.converters;

import icy.image.IcyBufferedImage;
import icy.sequence.Sequence;
import icy.type.DataType;
import ij.ImagePlus;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.converters.AbstractCLIJConverter;
import net.haesleinhuepf.clij.converters.CLIJConverterPlugin;
import net.haesleinhuepf.clij.converters.implementations.RandomAccessibleIntervalToClearCLBufferConverter;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import net.imglib2.RandomAccessibleInterval;
import net.imglib2.img.display.imagej.ImageJFunctions;
import org.scijava.plugin.Plugin;

import java.nio.ByteBuffer;
import java.nio.FloatBuffer;
import java.nio.ShortBuffer;
import java.util.ArrayList;

/**
 * Author: haesleinhuepf
 *         August 2019
 */
@Plugin(type = CLIJConverterPlugin.class)
public class SequenceToClearCLBufferConverter extends AbstractCLIJConverter<Sequence, ClearCLBuffer> {

    @Override
    public ClearCLBuffer convert(Sequence source) {
        long[] dimensions = new long[2];
        ArrayList<IcyBufferedImage> images = source.getAllImage();

        if (images.size() > 1) {
            dimensions = new long[3];
            dimensions[2] = images.size();
        }
        dimensions[0] = source.getWidth();
        dimensions[1] = source.getHeight();

        int numberOfPixelsPerSlice = (int)(dimensions[0] * dimensions[1]);
        long numberOfPixels = numberOfPixelsPerSlice;

        //NativeTypeEnum type;
        if (source.getDataType_() == DataType.UBYTE) {
            ClearCLBuffer target = clij.createCLBuffer(dimensions, NativeTypeEnum.UnsignedByte);

            byte[] inputArray = new byte[(int) numberOfPixels];
            for (int z = 0; z < target.getDepth(); z++) {
                byte[] sourceArray = images.get(z).getDataXYAsByte(0);
                System.arraycopy(sourceArray, 0, inputArray, z * numberOfPixelsPerSlice, sourceArray.length);
            }
            ByteBuffer byteBuffer = ByteBuffer.wrap(inputArray);
            target.readFrom(byteBuffer, true);
            return target;

        } else if (source.getDataType_() == DataType.USHORT) {
            ClearCLBuffer target = clij.createCLBuffer(dimensions, NativeTypeEnum.UnsignedShort);

            //time = System.currentTimeMillis();
            short[] inputArray = new short[(int) numberOfPixels];
            for (int z = 0; z < target.getDepth(); z++) {
                short[] sourceArray = images.get(z).getDataXYAsShort(0);
                System.arraycopy(sourceArray, 0, inputArray, z * numberOfPixelsPerSlice, sourceArray.length);
            }
            //IJ.log("Copy1 took " + (System.currentTimeMillis() - time));

            ShortBuffer byteBuffer = ShortBuffer.wrap(inputArray);
            target.readFrom(byteBuffer, true);
            return target;
        } else  if (source.getDataType_() == DataType.FLOAT) {
            ClearCLBuffer target = clij.createCLBuffer(dimensions, NativeTypeEnum.Float);

            float[] inputArray = new float[(int) numberOfPixels];
            for (int z = 0; z < target.getDepth(); z++) {
                float[] sourceArray = images.get(z).getDataXYAsFloat(0);
                System.arraycopy(sourceArray, 0, inputArray, z * numberOfPixelsPerSlice, sourceArray.length);
            }
            FloatBuffer byteBuffer = FloatBuffer.wrap(inputArray);
            target.readFrom(byteBuffer, true);
            return target;
        } else {
            throw new IllegalArgumentException("CLICY converter doesn't support type " + source.getDataType_() + " yet.");
        }
    }

    public ClearCLBuffer convertLegacy(ImagePlus source) {
        RandomAccessibleInterval rai = ImageJFunctions.wrapReal(source);
        RandomAccessibleIntervalToClearCLBufferConverter raitcclbc = new RandomAccessibleIntervalToClearCLBufferConverter();
        raitcclbc.setCLIJ(clij);
        return raitcclbc.convert(rai);
    }

    @Override
    public Class<Sequence> getSourceType() {
        return Sequence.class;
    }

    @Override
    public Class<ClearCLBuffer> getTargetType() {
        return ClearCLBuffer.class;
    }
}
