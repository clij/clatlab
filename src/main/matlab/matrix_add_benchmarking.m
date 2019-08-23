clatlab = init_clatlab();
mocl = clatlab.mocl;

A = mocl.ones(1000) * 3 + 5;
B = mocl.ones(1000) * 3 + 5;

before_gpu = now;
C = A + B;
duration_gpu = now - before_gpu
C_ = mocl.pull(C);

a = mocl.pull(A);
b = mocl.pull(B);

before_cpu = now;
c_ = a + b;
duration_cpu = now - before_cpu


c_;
