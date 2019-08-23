clatlab = init_clatlab()
mocl = clatlab.mocl;

a = [1 2 3; 2 3 4]
b = [2 2; 2 4; 4 4]

A = mocl.push(a);
B = mocl.push(b);

C = A * B;

c = mocl.pull(C)

c_ = a * b