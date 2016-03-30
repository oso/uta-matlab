close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 0);

na = 100
ncriteria = 4

% domains of the criteria
xdomains = repmat([0 1], ncriteria, 1);

% number of segments
nsegs = repmat([5], ncriteria, 1);

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

% nsegs per criterion
nsegs2 = repmat([5], ncriteria, 1);

% compute value functions
[xpts2, uis2, cvx_status] = uta_learn(nsegs2, xdomains, pt, pairwisecmp);

% check cvx status
k = strfind(cvx_status, 'Solved');
if length(k) < 1
	fprintf('error: cvx_status: %s\n', cvx_status);
end

% Check that umax is equal to 1
umax = uta(xpts2, uis2, xdomains(:,2)')

% Compute utilities with the polynomials
u2 = uta(xpts2, uis2, pt);

% Compute the ranking
ranking2 = compute_ranking(u2);
[ranking'; ranking2'; u'; u2']'

% Compute spearman distance and kendall tau
spearmand = compute_spearman_distance(ranking, ranking2)
kendallt = compute_kendall_tau(ranking, ranking2)

% plot UTA piecewise linear functions
figure

nplotsperline = 4;
nlines = ceil((ncriteria + 1) / nplotsperline);
cmap = distinguishable_colors(2);
%cmap = hsv(length(degrees) + 1);
plots = [];

plotstr = sprintf('original');
plotrefs = plot_pl_utilities(xpts, uis, '-*', cmap(1,:), plotstr, ...
			     nplotsperline);
plots(1) = plotrefs(1);

plotstr = sprintf('learned');
plotrefs = plot_pl_utilities(xpts2, uis2, '-*', cmap(2,:), plotstr, ...
			     nplotsperline);
plots(2) = plotrefs(2);

sh = subplot(nlines, nplotsperline, nplotsperline * nlines);
axis off;
legend(sh, plots);
