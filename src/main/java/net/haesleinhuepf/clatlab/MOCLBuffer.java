package net.haesleinhuepf.clatlab;

import net.haesleinhuepf.clij.clearcl.ClearCLBuffer;

/**
 * MOCLBuffer
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
        mocl.clij2.addImageAndScalar(input.buffer, output, new Float(scalar));
        return new MOCLBuffer(mocl, output);
    }
    public MOCLBuffer plus(MOCLBuffer input2) {
        MOCLBuffer input1 = this;
        System.out.println("MOCL plus");
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.addImages(input1.buffer, input2.buffer, output);
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
        mocl.clij2.addImagesWeighted(input1.buffer, input2.buffer, output, 1f, -1f);
        return new MOCLBuffer(mocl, output);
    }

    //-a
    //uminus(a)
    //Unary minus
    public MOCLBuffer uminus() {
        MOCLBuffer input1 = this;
        System.out.println("MOCL uminus");
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.invert(input1.buffer, output);
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
        mocl.clij2.transposeXY(input.buffer, output);
        return new MOCLBuffer(mocl, output);
    }


    //a.*b
    //times(a,b)
    //Element-wise multiplication
    public MOCLBuffer times(double scalar) {
        MOCLBuffer input = this;
        System.out.println("MOCL times");
        ClearCLBuffer output = mocl.clij2.create(input.buffer);
        mocl.clij2.multiplyImageAndScalar(input.buffer, output, new Float(scalar));
        return new MOCLBuffer(mocl, output);
    }

    public MOCLBuffer times(MOCLBuffer input2) {
        MOCLBuffer input1 = this;
        System.out.println("MOCL times");
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.multiplyImages(input1.buffer, input2.buffer, output);
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
        MOCLBuffer input1 = this;
        System.out.println("MOCL mtimes");
        ClearCLBuffer output = mocl.clij2.create(new long[]{input1.buffer.getWidth(), input2.buffer.getHeight()}, input1.buffer.getNativeType());
        mocl.clij2.multiplyMatrix(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a./b
    //rdivide(a,b)
    //Right element-wise division
    public MOCLBuffer rdivide(MOCLBuffer input2) {
        System.out.println("MOCL rdivide");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.divideImages(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a.\b
    //ldivide(a,b)
    //Left element-wise division
    public MOCLBuffer ldivide(MOCLBuffer input2) {
        System.out.println("MOCL ldivide");
        return input2.rdivide(this);
    }

    //a.^b
    //power(a,b)
    //Element-wise power
    public MOCLBuffer power(MOCLBuffer input2) {
        System.out.println("MOCL power");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.powerImages(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a < b
    //lt(a,b)
    //Less than
    public MOCLBuffer lt(MOCLBuffer input2) {
        System.out.println("MOCL lt");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.smaller(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }
        //a > b
    //gt(a,b)
    //Greater than
    public MOCLBuffer gt(MOCLBuffer input2) {
        System.out.println("MOCL gt");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.greaterOrEqual(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a <= b
    //le(a,b)
    //Less than or equal to
    public MOCLBuffer le(MOCLBuffer input2) {
        System.out.println("MOCL le");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.smallerOrEqual(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a >= b
    //ge(a,b)
    //Greater than or equal to
    public MOCLBuffer ge(MOCLBuffer input2) {
        System.out.println("MOCL ge");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.greaterOrEqual(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a ~= b
    //ne(a,b)
    //Not equal to
    public MOCLBuffer ne(MOCLBuffer input2) {
        System.out.println("MOCL ne");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.notEqual(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a == b
    //eq(a,b)
    //Equality
    public MOCLBuffer eq(MOCLBuffer input2) {
        System.out.println("MOCL eq");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.equal(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a & b
    //and(a,b)
    //Logical AND
    public MOCLBuffer and(MOCLBuffer input2) {
        System.out.println("MOCL and");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.binaryAnd(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //a | b
    //or(a,b)
    //Logical OR
    public MOCLBuffer or(MOCLBuffer input2) {
        System.out.println("MOCL or");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.binaryOr(input1.buffer, input2.buffer, output);
        return new MOCLBuffer(mocl, output);
    }

    //~a
    //not(a)
    //Logical NOT
    public MOCLBuffer not() {
        System.out.println("MOCL power");
        MOCLBuffer input1 = this;
        ClearCLBuffer output = mocl.clij2.create(input1.buffer);
        mocl.clij2.binaryNot(input1.buffer, output);
        return new MOCLBuffer(mocl, output);
    }
}
