close all; clear all; clc;

% init pseudo-random number generator
rand('seed', 1)

ncriteria = 5
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
ucats = linspace(0, 1, ncategories + 1);
ucats = ucats(2:ncategories)

% generate random performance table
na = 1000;
pt = random_pt(na, xdomains)

% compute assignments
u = uta(xpts, uis, pt);
assignments = utasort(ucats, u)

% degree of the polynoms
degree = 4

% compute polynoms
[pcoefs, ucats2] = utapol(degree, xdomains, ncategories, pt, assignments)

% plot UTA picewise linear functions and polynoms
figure
for i = 1:ncriteria
	subplot(2, ncriteria, i);
	plot(xpts(i,:), uis(i,:), xpts(i,:), uis(i,:), 'b*');
end

for i = 1:ncriteria
	subplot(2, ncriteria, ncriteria + i);
	x = xdomains(i,1):0.001:xdomains(i,2);
	uval = polyval(pcoefs(i,:), x);
	plot(x, uval);
end

% Check that umax is equal to 1
umax = 0;
for i = 1:ncriteria
	umax = umax + polyval(pcoefs(i,:), xdomains(i, 2));
end
umax

% Assign the alternatives with the polynom
u2 = utap(pcoefs, pt);
assignments2 = utasort(ucats2, u2)

% Compute classification accuracy
assign_diff = assignments - assignments2;
errors = size(find(assign_diff > 0), 1);
ca = (na - errors) / na
