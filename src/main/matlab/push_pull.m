clatlab = init_clatlab();
mocl = clatlab.mocl

A = clatlab.push([1 2 3])

a = clatlab.pull(A)

B = mocl.push([1 2 3])

b = mocl.pull(A)