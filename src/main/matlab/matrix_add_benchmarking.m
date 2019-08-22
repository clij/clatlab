clatlab = init_clatlab();
clm = clatlab.m;

a = ones(10000, 1) * 6 + 8;
b = ones(10000, 1) * 67 + 6;

A = clatlab.push(a);
B = clatlab.push(b);

before_gpu = now;

C = clm.plus(A, B);

duration_gpu = now - before_gpu

c = clatlab.pull(C);

before_cpu = now;
c_ = a + b;
duration_cpu = now - before_cpu


c_;
