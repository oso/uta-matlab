function y = m2u1(x)

t0 = 0.5;
beta = 15;
y = 1 ./ (1 + exp(-beta .* (x - t0)));
