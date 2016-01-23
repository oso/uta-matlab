function y = m4u1(x)

xi = [0 0.3 0.9 1];
yi = [0 0.1 0.7 1];
y = interp1(xi, yi, x);
