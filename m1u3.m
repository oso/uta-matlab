function y = m1u3(x)

xi = [0 0.3 0.4 0.6 1];
yi = [0 0.2 0.8 0.9 1];
y = interp1(xi, yi, x);
