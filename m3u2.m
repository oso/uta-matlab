function y = m3u2(x)

xi = [0 0.4 0.7 1];
yi = [0 0.6 0.7 1];
y = interp1(xi, yi, x);
