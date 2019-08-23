package net.haesleinhuepf.clatlab;

import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;
import net.haesleinhuepf.clij.coremem.enums.NativeTypeEnum;

/**
 * MOCLBuffer
 * <p>
 * <p>
 * <p>
 * Author: @haesleinhuepf
 * 08 2019
 */
public class MOCLBuffer {

    MOCL mocl;
    ClearCLBuffer buffer;

    MOCLBuffer (MOCL mocl, ClearCLBuffer buffer) {
        this.mocl = mocl;
        this.buffer = buffer;
    }

    // a + b
    //plus(a,b)
    //Binary addition
    public MOCLBuffer plus(double scalar) {
        System.out.println("MOCL plus");
        MOCLBuffer input = this;
        ClearCLBuffer output = mocl.clij2.create(input.buffer);
        mocl.clij2.op.addImageAndScalar(input.buffer, output, new Float(scalar));
        return new MOCLBuffer(mocl, output);
    }
    public MOCLBuffer plus(MOCLBuffer input2) {
        MOCLBuffer input1 = this;
        System.out.println("MOCL plus");
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.op.addImages(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a - b
    //minus(a,b)
    //Binary subtraction
    public MOCLBuffer minus(double scalar) {
        return plus(-scalar);
    }
    public MOCLBuffer minus(MOCLBuffer input2) {
        MOCLBuffer input1 = this;
        System.out.println("MOCL minus");
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.op.addImagesWeighted(input1.buffer, input2.buffer, output, 1f, -1f);
        return new MOCLBuffer(mocl, output);
    }


    //a.'
    //transpose(a)
    //Matrix transpose
    public MOCLBuffer transpose() {
        MOCLBuffer input = this;
        System.out.println("MOCL transpose");
        ClearCLBuffer output;
        if (input.buffer.getDimension() == 2) {
            output = mocl.clij2.create(new long[]{input.buffer.getHeight(), input.buffer.getWidth()}, input.buffer.getNativeType());
        } else {
            output = mocl.clij2.create(new long[]{input.buffer.getHeight(), input.buffer.getWidth(), input.buffer.getDepth()}, input.buffer.getNativeType());
        }
        mocl.clij2.op.transposeXY(input.buffer, output);
        return new MOCLBuffer(mocl, output);
    }


    //a.*b
    //times(a,b)
    //Element-wise multiplication
    public MOCLBuffer times(double scalar) {
        MOCLBuffer input = this;
        System.out.println("MOCL times");
        ClearCLBuffer output = mocl.clij2.create(input.buffer);
        mocl.clij2.op.multiplyImageAndScalar(input.buffer, output, new Float(scalar));
        return new MOCLBuffer(mocl, output);
    }

    public MOCLBuffer times(MOCLBuffer input2) {
        MOCLBuffer input1 = this;
        System.out.println("MOCL times");
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.op.multiplyImages(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a*b
    //mtimes(a,b)
    //Matrix multiplication
    public MOCLBuffer mtimes(double scalar) {
        System.out.println("MOCL mtimes");
        return times(scalar);
    }

    public MOCLBuffer mtimes(MOCLBuffer input2) {
        //TODO
        System.out.println("not implemented yet");
        return null;
    }

    //a./b
    //rdivide(a,b)
    //Right element-wise division
    public MOCLBuffer rdivide(MOCLBuffer input2) {
        System.out.println("MOCL rdivide");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.op.divideImages(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }


    //a.\b
    //ldivide(a,b)
    //Left element-wise division
    public MOCLBuffer ldivide(MOCLBuffer input2) {
        System.out.println("MOCL ldivide");
        return input2.rdivide(this);
    }


    public MOCLBuffer colon(int min, int max) {
        System.out.println("MOCL colon2");
        ClearCLBuffer intensities = mocl.clij2.create(new long[]{max-min + 1, 1}, NativeTypeEnum.Float);
        ClearCLBuffer temp = mocl.clij2.create(intensities);
        mocl.clij2.op.set(intensities, 1f);
        mocl.clij2.op.multiplyImageAndCoordinate(intensities, temp, 0);
        mocl.clij2.op.addImageAndScalar(temp, intensities, new Float(min));
        temp.close();
        return new MOCLBuffer(mocl, intensities);
    }

    public MOCLBuffer colon(int min, int step, int max) {
        System.out.println("MOCL colon3");
        ClearCLBuffer intensities = mocl.clij2.create(new long[]{(max-min)/step + 1, 1}, NativeTypeEnum.Float);
        ClearCLBuffer temp = mocl.clij2.create(intensities);
        mocl.clij2.op.set(intensities, 1f);
        mocl.clij2.op.multiplyImageAndCoordinate(intensities, temp, 0);
        mocl.clij2.op.multiplyImageAndScalar(temp, intensities, new Float(step));
        mocl.clij2.op.addImageAndScalar(intensities, temp, new Float(min));
        intensities.close();
        return new MOCLBuffer(mocl, temp);
    }

    //-a
    //uminus(a)
    //Unary minus

    //+a
    //uplus(a)
    //Unary plus

    //a/b
    //mrdivide(a,b)
    //Matrix right division

    //a\b
    //mldivide(a,b)
    //Matrix left division

    //a.^b
    //power(a,b)
    //Element-wise power

    //a^b
    //mpower(a,b)
    //Matrix power

    //a < b
    //lt(a,b)
    //Less than

    //a > b
    //gt(a,b)
    //Greater than

    //a <= b
    //le(a,b)
    //Less than or equal to

    //a >= b
    //ge(a,b)
    //Greater than or equal to

    //a ~= b
    //ne(a,b)
    //Not equal to

    //a == b
    //eq(a,b)
    //Equality

    //a & b
    //and(a,b)
    //Logical AND

    //a | b
    //or(a,b)
    //Logical OR

    //~a
    //not(a)
    //Logical NOT

    //a:d:b
    //a:b
    //colon(a,d,b)
    //colon(a,b)
    //Colon operator

    //a'
    //ctranspose(a)
    //Complex conjugate transpose


    //[a b]
    //horzcat(a,b,...)
    //Horizontal concatenation

    //[a; b]
    //vertcat(a,b,...)
    //Vertical concatenation

    //a(s1,s2,...sn)
    //subsref(a,s)
    //Subscripted reference

    //a(s1,...,sn) = b
    //subsasgn(a,s,b)
    //Subscripted assignment

    //b(a)
    //subsindex(a)
    //Subscript index
}
