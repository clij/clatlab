package net.haesleinhuepf.clicy;

import icy.sequence.Sequence;
import net.haesleinhuepf.clicy.converters.ClearCLBufferToSequenceConverter;
import net.haesleinhuepf.clicy.converters.SequenceToClearCLBufferConverter;
import net.haesleinhuepf.clij.CLIJ;
import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;
import net.haesleinhuepf.clij.utilities.CLIJOps;

public class CLICY {
    private static CLICY instance;
    private final CLIJ clij;

    private CLICY(CLIJ clij) {
        this.clij = clij;
    }

    public static CLICY getInstance() {
        if (instance == null) {
            instance = new CLICY(CLIJ.getInstance());
        }
        return instance;
    }

    public CLICY getInstance(String id) {
        if (instance == null) {
            instance = new CLICY(CLIJ.getInstance(id));
        }
        return instance;
    }

    public ClearCLBuffer push(Sequence sequence) {
        SequenceToClearCLBufferConverter converter = new SequenceToClearCLBufferConverter();
        converter.setCLIJ(clij);
        return converter.convert(sequence);
                //clij.convert(sequence, ClearCLBuffer.class);
    }

    public Sequence pull(ClearCLBuffer buffer) {
        ClearCLBufferToSequenceConverter converter = new ClearCLBufferToSequenceConverter();
        converter.setCLIJ(clij);
        return converter.convert(buffer);
                //clij.convert(buffer, Sequence.class);
    }

    public ClearCLBuffer create(long[] dimensions, NativeTypeEnum type) {
        return clij.create(dimensions, type);
    }

    public ClearCLBuffer create(ClearCLBuffer buffer) {
        return clij.create(buffer);
    }

    public CLIJOps op() {
        return clij.op();
    }

    public String getGPUName() {
        return clij.getGPUName();
    }
}
