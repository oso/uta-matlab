close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 12);

na = 50
ncriteria = 5

% domains of the criteria
xdomains = repmat([0 1], ncriteria, 1);

% number of segments
nsegs = repmat([4], ncriteria, 1);

% generate random UTA functions
[xpts, uis] = uta_random(xdomains, nsegs);
xpts

% generate random performance table
pt = pt_random(na, xdomains);

% compute assignments
u = uta(xpts, uis, pt);

% compute ranking
ranking = compute_ranking(u)

% compute preferences relations
pairwisecmp = compute_pairwise_relations(u);

results = cell(1, 3);

	% compute polynoms
	[pcoefs, cvx_status] = utas_learn(nsegs, xdomains, ...
					  pt, pairwisecmp);

	% check cvx status
	k = strfind(cvx_status, 'Solved');
	if length(k) < 1
		fprintf('error: cvx_status: %s\n', cvx_status);
	end

	% Check that umax is equal to 1
	umax = 0;
	for j = 1:ncriteria
		umax = umax + utas(xpts, pcoefs, xdomains(j, 2));
	end
	umax

	% Compute utilities with the polynomials
	u2 = utas(xpts, pcoefs, pt);

	% Compute the ranking
	ranking2 = compute_ranking(u2);

	% Compute spearman distance
	spearmand = compute_spearman_distance(ranking, ranking2)
	kendallt = compute_kendall_tau(ranking, ranking2)

% plot UTA piecewise linear functions and polynoms
figure

nplotsperline = 4;
nlines = ceil((ncriteria) / nplotsperline) + 1;
plots = [];

plotstr = sprintf('plinear');
%cmap = hsv(2);
cmap = distinguishable_colors(2);
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

	sd = spearmand;
	kt = kendallt;

	plotrefs = plot_splines_utilities(pcoefs, xpts, '-', ...
				          cmap(2,:), plotstr, ...
				          nplotsperline);
	% print polynomials
	for j = 1:ncriteria
		fprintf('u_%d: %s\n', j, print_poly(pcoefs(j, :)));
	end

	% print CA
	fprintf('Spearman distance: %g\n', sd);
	fprintf('Kendall tau: %g\n', kt);

sh = subplot(nlines, nplotsperline, nplotsperline * nlines);
axis off;
legend(sh, plots);
sh = subplot(nlines, nplotsperline, nplotsperline * nlines - 2);
axis off;
legend(sh, plots);
