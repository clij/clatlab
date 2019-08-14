importClass(net.haesleinhuepf.clicy.CLICY);
importClass(Packages.icy.main.Icy);

// init clicy
clicy = CLICY.getInstance();
print(clicy.getGPUName());

// get current image from Icy
sequence = getSequence();

// push image to GPU
inputBuffer = clicy.push(sequence);
// allocate memory on GPU for the result
outputBuffer = clicy.create(inputBuffer);

// process image on GPU
clicy.op().blur(inputBuffer, outputBuffer, 5, 5);

// pull result back from GPU
output = clicy.pull(outputBuffer);

// Show result
Icy.addSequence(output);

// clean up
inputBuffer.close();
outputBuffer.close();

