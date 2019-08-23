clatlab = init_clatlab();
mocl = clatlab.m;

A = mocl.ones(1000) * 3 + 5;
B = mocl.ones(1000) * 3 + 5;

before_gpu = now;
C = A + B;
duration_gpu = now - before_gpu
C_ = mocl.mat(C);

a = mocl.mat(A);
b = mocl.mat(B);

before_cpu = now;
c_ = a + b;
duration_cpu = now - before_cpu


c_;
