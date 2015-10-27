close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 1234);

na = 100
ncriteria = 5
ncategories = 7

% domains of the criteria
xdomains = repmat([0 1], ncriteria, 1);

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

% degrees of the polynomials
nsegs2 = repmat([10], ncriteria, 1);
xpts_splines = xlinspace(xdomains, nsegs2);
degrees = [3];
deg_continuity = 2;

results = cell(1, 3);

for i = 1:length(degrees)
	deg = degrees(i)

	% compute polynoms
	[pcoefs, ucats2, cvx_status] = utadiss_learn2(nsegs2, deg, ...
						      deg_continuity, ...
						      xdomains, ...
						      ncategories, pt, ...
						      assignments);
	pcoefs

	% check cvx status
	k = strfind(cvx_status, 'Solved');
	if length(k) < 1
		fprintf('error: cvx_status: %s\n', cvx_status);
	end

	% Check that umax is equal to 1
	umax = 0;
	for j = 1:ncriteria
		umax = umax + polyval(pcoefs(j,:,nsegs2(j)), xdomains(j, 2));
	end
	umax

	% Assign the alternatives with the polynom
	u2 = utas(xpts_splines, pcoefs, pt);
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

	plotrefs = plot_splines_utilities(pcoefs, xpts_splines, '-', ...
				          cmap(i+1, :), plotstr, ...
				          nplotsperline);
	plots(i + 1) = plotrefs(1);

	% print degree
	fprintf('\nDegree %d\n', deg);
	fprintf('========\n\n');

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
