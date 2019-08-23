clatlab = init_clatlab();
mocl = clatlab.mocl;

A = mocl.ones(10, 1) * 6 + 8;
B = mocl.ones(10, 1) * 67 + 6;
C = A + B;

a = ones(10, 1) * 6 + 8;
b = ones(10, 1) * 67 + 6;

c = mocl.pull(C)
c_ = a + b
