clatlab = init_clatlab()
clm = clatlab.m;

a = [1 2 3; 2 3 4]
b = [2 2 2; 4 4 4]

A = clatlab.push(a);
B = clatlab.push(b);

C = clm.dotStar(A, B);

c = clatlab.pull(C)

c_ = a .* b