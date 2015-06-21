degree = 2

data = csvread('pralines2.csv', 0, 1);
values = data(1, :);
occurences = data(2:size(data, 1), :);

xdomain = [min(values) max(values)];

pairwisecmp = [zeros(1, 3)];
ncmp = size(occurences, 1) - 1;
for i = 1:ncmp
	pairwisecmp(i, :) = [i + 1, i, 1];
end

pcoefs = utap_pralines_learn(degree, xdomain, values, occurences, pairwisecmp)

u = utap_pralines(pcoefs, values, occurences)
compute_ranking(u)

x = linspace(xdomain(1), xdomain(2));
uval = polyval(pcoefs, x);
plot(x, uval)
