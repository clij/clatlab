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

import java.awt.image.BufferedImage;
import java.nio.ByteBuffer;
import java.nio.FloatBuffer;
import java.nio.ShortBuffer;
import java.util.ArrayList;

/**
 * Author: haesleinhuepf
 *         August 2019
 */
@Plugin(type = CLIJConverterPlugin.class)
public class ClearCLBufferToSequenceConverter extends AbstractCLIJConverter<ClearCLBuffer, Sequence> {

    @Override
    public Sequence convert(ClearCLBuffer source) {
        long numberOfPixels = source.getWidth() * source.getHeight() * source.getDepth();
        int numberOfPixelsPerPlane = (int) (source.getWidth() * source.getHeight());
        int depth = (int) source.getDepth();

        Sequence sequence = new Sequence();

        DataType dataType;
        if (source.getNativeType() == NativeTypeEnum.UnsignedByte) {
            dataType = DataType.UBYTE;
        } else if (source.getNativeType() == NativeTypeEnum.UnsignedShort) {
            dataType = DataType.USHORT;
        } else if (source.getNativeType() == NativeTypeEnum.Float) {
            dataType = DataType.FLOAT;
        } else {
            throw new IllegalArgumentException("Datatype " + source.getNativeType() + " is not supported by CLICY yet.");
        }

        if (source.getNativeType() == NativeTypeEnum.UnsignedByte) {
            byte[] array = new byte[(int) numberOfPixels];
            ByteBuffer buffer = ByteBuffer.wrap(array);
            source.writeTo(buffer, true);

            for (int z = 0; z < depth; z++) {
                byte[] sliceArray = new byte[numberOfPixelsPerPlane];

                System.arraycopy(array, z * numberOfPixelsPerPlane, sliceArray, 0, sliceArray.length);
                IcyBufferedImage image = new IcyBufferedImage((int)source.getWidth(), (int)source.getHeight(), 1, dataType);

                image.setDataXYAsByte(0, sliceArray);

                sequence.addImage(image);
            }
        } else if (source.getNativeType() == NativeTypeEnum.UnsignedShort) {
            short[] array = new short[(int) numberOfPixels];
            ShortBuffer buffer = ShortBuffer.wrap(array);
            source.writeTo(buffer, true);

            for (int z = 0; z < depth; z++) {
                //result.setSlice(z + 1);
                short[] sliceArray = new short[numberOfPixelsPerPlane];

                System.arraycopy(array, z * numberOfPixelsPerPlane, sliceArray, 0, sliceArray.length);
                IcyBufferedImage image = new IcyBufferedImage((int)source.getWidth(), (int)source.getHeight(), dataType);
                image.setDataXYAsShort(0, sliceArray);
                sequence.addImage(image);
            }
        } else if (source.getNativeType() == NativeTypeEnum.Float) {
            float[] array = new float[(int) numberOfPixels];
            FloatBuffer buffer = FloatBuffer.wrap(array);
            source.writeTo(buffer, true);

            for (int z = 0; z < depth; z++) {
                //result.setSlice(z + 1);
                float[] sliceArray = new float[numberOfPixelsPerPlane];

                System.arraycopy(array, z * numberOfPixelsPerPlane, sliceArray, 0, sliceArray.length);
                IcyBufferedImage image = new IcyBufferedImage((int)source.getWidth(), (int)source.getHeight(), dataType);
                image.setDataXYAsFloat(0, sliceArray);
                sequence.addImage(image);
            }
        }

        return sequence;
    }

    @Override
    public Class<ClearCLBuffer> getSourceType() {
        return ClearCLBuffer.class;
    }

    @Override
    public Class<Sequence> getTargetType() {
        return Sequence.class;
    }
}
