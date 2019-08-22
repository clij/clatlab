clatlab = init_clatlab()
clm = clatlab.m;

a = [1 2 3 4 5 6]' * [2 3 4 5 6 7];
b = [1 2 3 4 5 6]' * [3 4 5 6 7 8];

before_gpu = now;
A = clatlab.push(a);
B = clatlab.push(b);
C = clm.dotStar(A, B);
c = clatlab.pull(C)
duration_gpu = now - before_gpu

before_cpu = now;
c_ = a .* b
duration_cpu = now - before_cpu