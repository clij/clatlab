clatlab = init_clatlab();
clm = clatlab.m;

a = ones(10, 1) * 6 + 8;
b = ones(10, 1) * 67 + 6;

A = clatlab.push(a);
B = clatlab.push(b);

C = clm.plus(A, B);

c = clatlab.pull(C)
c_ = a + b
