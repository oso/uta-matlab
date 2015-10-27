close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 12);

na = 100
ncriteria = 4

% domains of the criteria
xdomains = repmat([0 1], ncriteria, 1);

% number of segments
nsegs = repmat([4], ncriteria, 1);

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

% degrees of the splines
degrees = [3];

% degree of continuity of the splines
deg_continuity = 2

results = cell(1, 3);

for i = 1:length(degrees)
	deg = degrees(i)

	% compute splines
	[xpts2, pcoefs, cvx_status] = utas_learn2(nsegs2, deg, ...
						  deg_continuity, ...
					          xdomains, pt, pairwisecmp);

	% check cvx status
	k = strfind(cvx_status, 'Solved');
	if length(k) < 1
		fprintf('error: cvx_status: %s\n', cvx_status);
	end

	% Check that umax is equal to 1
	umax = utas(xpts2, pcoefs, xdomains(:,2)')

	% Compute utilities with the polynomials
	u2 = utas(xpts2, pcoefs, pt);

	% Compute the ranking
	ranking2 = compute_ranking(u2);
	[ranking'; ranking2'; u'; u2']'

	% Compute spearman distance
	spearmand = compute_spearman_distance(ranking, ranking2)
	kendallt = compute_kendall_tau(ranking, ranking2)

	% Store results, spearman distance and kendall tau
	results(i, 1) = {pcoefs};
	results(i, 2) = {spearmand};
	results(i, 3) = {kendallt};
end

% plot UTA piecewise linear functions and polynoms
figure

nplotsperline = 4;
nlines = ceil((ncriteria) / nplotsperline) + 1;
cmap = distinguishable_colors(length(degrees) + 1);
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

	plotrefs = plot_splines_utilities(pcoefs, xpts2, '-', ...
				          cmap(i+1, :), plotstr, ...
				          nplotsperline);

	plots(i + 1) = plotrefs(1);

	% print accuracy
	fprintf('\ndegree: %d\n', deg);
	fprintf('Spearman distance: %g\n', sd);
	fprintf('Kendall tau: %g\n', kt);
end

sh = subplot(nlines, nplotsperline, nplotsperline * nlines);
axis off;
legend(sh, plots);
sh = subplot(nlines, nplotsperline, nplotsperline * nlines - 2);
axis off;
legend(sh, plots);
