clatlab = init_clatlab();
clm = clatlab.m;

% an array containing 1
A = clm.ones(3)
a = clatlab.pull(A)
a_ = ones(3)

% an array containing 0
B = clm.zeros(4)
b = clatlab.pull(B)
b_ = zeros(4)

% an array of unknown content (not random)
C = clm.anys(5);
c = clatlab.pull(C)


D = clm.zeros(3, 1)
d = clatlab.pull(D)
d_ = zeros(3, 1)

E = clm.zeros(3, 2, 1)
e = clatlab.pull(E)
e_ = zeros(3, 2, 1)

F = clm.zeros(4, 3, 2)
f = clatlab.pull(F)
f_ = zeros(4, 3, 2)

g = clatlab.pull(clm.colon(0, 4))
g_ = (0:4)

h = clatlab.pull(clm.colonColon(0, 2, 8))
h_ = (0:2:8)
