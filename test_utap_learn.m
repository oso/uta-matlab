close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 123);

na = 100
ncriteria = 5
ncategories = 3

% domains of the criteria
xdomains = repmat([-1 1], ncriteria, 1);

% number of segments
nsegs = repmat([10], ncriteria, 1);

% generate random UTA functions
[xpts, uis] = uta_random(xdomains, nsegs);

% generate category thresholds
%ucats = sort(rand(1, ncategories - 1))
ucats = linspace(0, 1, ncategories + 1);
ucats = ucats(2:ncategories);

% generate random performance table
pt = pt_random(na, xdomains);

% compute assignments
u = uta(xpts, uis, pt);
assignments = utasort(ucats, u);

% degrees of the polynoms
degrees = [3 4 5];

results = cell(3);

for i = 1:length(degrees)
	deg = degrees(i)

	% compute polynoms
	[pcoefs, ucats2] = utap_learn(deg, xdomains, ncategories, pt, ...
				      assignments);

	% Check that umax is equal to 1
	umax = 0;
	for j = 1:ncriteria
		umax = umax + polyval(pcoefs(j,:), xdomains(j, 2));
	end
	umax

	% Assign the alternatives with the polynom
	u2 = utap(pcoefs, pt);
	assignments2 = utasort(ucats2, u2);

	% Compute classification accuracy
	assign_diff = assignments - assignments2;
	errors = size(find(assign_diff > 0), 1);
	ca = (na - errors) / na;

	% Store ca, polynoms and category limits
	results(i,1) = {pcoefs};
	results(i,2) = {ucats2};
	results(i,3) = {ca};
end

% plot UTA piecewise linear functions and polynoms
figure

nsubx = 4;
nsuby = ceil((ncriteria) / nsubx) + 1;
%cmap = distinguishable_colors(length(degrees) + 1)
cmap = hsv(length(degrees) + 1);
plots = [];

for j = 1:ncriteria
	subplot(nsuby, nsubx, j);

	hold on;
	axis on;

	ustr = sprintf('%g ', ucats);
	plotstr = sprintf('plinear;  U [%s]', ustr);

	plots(1) = plot(xpts(j,:), uis(j,:), '-*', 'Color', cmap(1,:), ...
			'DisplayName', plotstr);

	hold off;
end

for i = 1:length(degrees)
	deg = degrees(i);

	for j = 1:ncriteria
		subplot(nsuby, nsubx, j);

		hold on;
		axis on;

		pcoefs = cell2mat(results(i, 1));
		ucats2 = cell2mat(results(i, 2));
		ca = cell2mat(results(i, 3));

		x = xdomains(j,1):0.001:xdomains(j,2);
		uval = polyval(pcoefs(j,:), x);

		ustr = sprintf('%g ', ucats2);
		plotstr = sprintf('degree %d; U [%s]; CA %g', deg, ustr, ca);

		plots(i+1) = plot(x, uval, 'Color', cmap(i+1,:), ...
				  'DisplayName', plotstr);

		hold off;
	end
end

sh = subplot(nsuby, nsubx, nsubx * nsuby);
axis off;
legend(sh, plots);
