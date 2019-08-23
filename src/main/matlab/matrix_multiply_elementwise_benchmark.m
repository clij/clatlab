clatlab = init_clatlab()
mocl = clatlab.mocl;

a = [1 2 3 4 5 6]' * [7 3 4 5 6 7];
b = [1 8 3 4 5 6]' * [3 4 5 6 7 8];

A = mocl.push(a);
B = mocl.push(b);
before_gpu = now;
C = A .* B;
duration_gpu = now - before_gpu
c = mocl.pull(C)

before_cpu = now;
c_ = a .* b
duration_cpu = now - before_cpu