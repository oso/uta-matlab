function y = m1u1(x)

xi = [0 0.2 0.6 1];
yi = [0 0.6 0.9 1];
y = interp1(xi, yi, x);
