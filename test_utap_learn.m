close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 12);

na = 100
ncriteria = 5

% domains of the criteria
xdomains = repmat([0 1], ncriteria, 1);

% number of segments
nsegs = repmat([3], ncriteria, 1);

% generate random UTA functions
[xpts, uis] = uta_random(xdomains, nsegs);

% generate random performance table
pt = pt_random(na, xdomains);

% compute assignments
u = uta(xpts, uis, pt);

% compute ranking
ranking = compute_ranking(u)

% compute preferences relations
pairwisecmp = compute_pairwise_relations(u);

% degrees of the polynoms
degrees = [3 4 5 6];

results = cell(1, 3);

for i = 1:length(degrees)
	deg = degrees(i)

	% compute polynoms
	[pcoefs, cvx_status] = utap_learn2(deg, xdomains, ...
					   pt, pairwisecmp);

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

	% Compute utilities with the polynomials
	u2 = utap(pcoefs, pt);

	% Compute the ranking
	ranking2 = compute_ranking(u2);

	% Compute spearman distance
	spearmand = compute_spearman_distance(ranking, ranking2);
	kendallt = compute_kendall_tau(ranking, ranking2);

	% Store polynoms and spearman distance and kendall tau
	results(i,1) = {pcoefs};
	results(i,2) = {spearmand};
	results(i,3) = {kendallt};
end

% plot UTA piecewise linear functions and polynoms
figure

nplotsperline = 4;
nlines = ceil((ncriteria) / nplotsperline) + 1;
cmap = distinguishable_colors(length(degrees) + 1)
%cmap = hsv(length(degrees) + 1);
plots = [];

plotstr = sprintf('plinear');
plotrefs = plot_pl_utilities(xpts, uis, '-*', cmap(1,:), plotstr, ...
			     nplotsperline);
plots(1) = plotrefs(1);

% print piecewise linear functions
fprintf('piecewise linear functions\n');
fprintf('==========================\n\n');
for j = 1:ncriteria
	str = print_pl(xpts(j,:), uis(j,:));
	fprintf('u_%d: %s\n', j, str);
end

for i = 1:length(degrees)
	deg = degrees(i);

	pcoefs = cell2mat(results(i, 1));
	sd = cell2mat(results(i, 2));
	kt = cell2mat(results(i, 3));

	plotstr = sprintf('degree %d; SD %g; KT %g', deg, sd, kt);

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

	% print CA
	fprintf('Spearman distance: %g\n', sd);
	fprintf('Kendall tau: %g\n', kt);
end

sh = subplot(nlines, nplotsperline, nplotsperline * nlines);
axis off;
legend(sh, plots);
sh = subplot(nlines, nplotsperline, nplotsperline * nlines - 2);
axis off;
legend(sh, plots);
