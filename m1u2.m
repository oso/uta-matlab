function y = m1u2(x)

xi = [0 0.1 0.2 0.7 0.9 1];
yi = [0 0.1 0.3 0.6 0.9 1];
y = interp1(xi, yi, x);
