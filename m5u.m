function [u, ui] = m5u(pt)

x = [0 0.5 1];
y = [0 0.1 0.4];
f1 = polyfit(x, y, 2);
f1 = f1 ./ polyval(f1, 1) * 0.4;

x = [0:0.01:0.1 0.3:0.01:0.5 0.7:0.01:1];
y = [0:0.002:0.02 0.19:0.001:0.21 0.38:0.001:0.41];
f2 = polyfit(x, y, 15);
f2 = f2 ./ polyval(f2, 1) * 0.4;

x = [0 0.5 1];
y = [0 0.15 0.2];
f3 = polyfit(x, y, 2);
f3 = f3 ./ polyval(f3, 1) * 0.2;

uf = zeros(3, 16);
uf(1,17-length(f1):16) = f1;
uf(2,17-length(f2):16) = f2;
uf(3,17-length(f3):16) = f3;

[u, ui] = utap(uf, pt);
