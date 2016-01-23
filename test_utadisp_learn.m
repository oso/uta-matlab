close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 13);

na = 10
ncriteria = 5
ncategories = 2

% domains of the criteria
xdomains = repmat([0 1], ncriteria, 1);

% number of segments
nsegs = repmat([1], ncriteria, 1);

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

%pt = [0 1; 1 0; 0.25 0.75; 0.75 0.25]
%assignments = [2, 2, 2, 1]'

% degrees of the polynoms
degrees = [9];

results = cell(1, 3);

for i = 1:length(degrees)
	deg = degrees(i)

	% compute polynoms
	[pcoefs, ucats2, cvx_status] = utadisp_learn(deg, xdomains, ...
						      ncategories, pt, ...
						      assignments);

	% check cvx status
	k = strfind(cvx_status, 'Solved');
	if length(k) < 1
		fprintf('error: cvx_status: %s\n', cvx_status);
	end

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
	ca = compute_ca(assignments, assignments2);

	% Store ca, polynoms and category limits
	results(i,1) = {pcoefs};
	results(i,2) = {ucats2};
	results(i,3) = {ca};
end

% plot UTA piecewise linear functions and polynoms
figure

nplotsperline = 4;
nlines = ceil((ncriteria) / nplotsperline) + 1;
%cmap = distinguishable_colors(length(degrees) + 1)
cmap = hsv(length(degrees) + 1);
plots = [];

ustr = sprintf('%g', ucats);
plotstr = sprintf('plinear;  U [%s]', ustr);
plotrefs = plot_pl_utilities(xpts, uis, '-*', cmap(1,:), plotstr, ...
			     nplotsperline);
plots(1) = plotrefs(1);

% print piecewise linear functions
fprintf('piecewise linear functions\n');
fprintf('==========================\n\n');
for j = 1:ncriteria
	str = print_pl(xpts(j,:), uis(j,:));
	fprintf('u_%d: %s\n', j, str);
	fprintf('U: %s\n', ustr);
end

for i = 1:length(degrees)
	deg = degrees(i);

	pcoefs = cell2mat(results(i, 1));
	ucats2 = cell2mat(results(i, 2));
	ca = cell2mat(results(i, 3));

	ustr = sprintf('%g ', ucats2);
	plotstr = sprintf('degree %d; U [%s]; CA %g', deg, ustr, ca);

	plotrefs = plot_poly_utilities(pcoefs, xdomains, '-', ...
				       cmap(i+1,:), plotstr, ...
				       nplotsperline);
	plots(i + 1) = plotrefs(1);

	% print degree
	fprintf('\nDegree %d\n', deg);
	fprintf('========\n\n');

	% print polynomials
	for j = 1:ncriteria
		fprintf('u_%d: %s\n', j, print_poly(pcoefs(j, :)));
	end

	% print uvals
	fprintf('U: %s\n', ustr);

	% print CA
	fprintf('CA: %g\n', ca);
end

sh = subplot(nlines, nplotsperline, nplotsperline * nlines);
axis off;
legend(sh, plots);
sh = subplot(nlines, nplotsperline, nplotsperline * nlines - 2);
axis off;
legend(sh, plots);
