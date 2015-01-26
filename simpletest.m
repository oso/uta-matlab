ndeg = 7;

syms x;
prog = sosprogram([x]);

z = monomials(x, [0:ndeg-1]);
[prog, p] = sospolyvar(prog, z);

prog = sosineq(prog, p - 1, [1 1]);
prog = sosineq(prog, 1 + 0.0001 - p, [1 1]);
prog = sosineq(prog, p - 2, [2 2]);
prog = sosineq(prog, 2 + 0.0001 - p, [2 2]);

prog = sossolve(prog)
p = sosgetsol(prog, p)

subs(p, x, 1)
subs(p, x, 2)

ezplot(p, [1 2])
