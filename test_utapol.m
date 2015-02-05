close all; clear all; clc;

% init pseudo-random number generator
rand('seed', 4)

ncriteria = 3
ncategories = 3

% domains of the criteria
xdomains = repmat([0 10], ncriteria, 1)

% number of segments
nsegs = repmat([4], ncriteria, 1);

% generate random UTA functions
[xpts, uis] = utarandom(xdomains, nsegs)

% generate category thresholds
ncategories = 3
%ucats = sort(rand(1, ncategories - 1))
ucats = linspace(0, 1, ncategories + 1)
ucats = ucats(2:ncategories)

% generate random performance table
na = 1000
pt = random_pt(na, xdomains)

% compute assignments
assignments = utasort(xpts, uis, ucats, pt)

% degree of the polynoms
degree = 5

% compute polynoms
[polynoms, ucats] = utapol(degree, xdomains, ncategories, pt, assignments)

% plot UTA picewise linear functions and polynoms
figure
for i = 1:ncriteria
	subplot(2, ncriteria, i);
	plot(xpts(i,:), uis(i,:), xpts(i,:), uis(i,:), 'b*');
end

for i = 1:ncriteria
	subplot(2, ncriteria, ncriteria + i);
	x = xdomains(i,1):0.001:xdomains(i,2);
	uval = 0;
	for d = 0:degree
		uval = uval + polynoms(i, d + 1) * x.^(d);
	end
	plot(x, uval);
end
