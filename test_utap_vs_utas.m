close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 1);

na = 100
ncriteria = 3

% domains of the criteria
xdomains = repmat([0 1], ncriteria, 1);

% number of segments
nsegs = repmat([10], ncriteria, 1);

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

degree_poly = 7
degree_splines = 7
degree_continuity = 2
nsegs2 = repmat([10], ncriteria, 1);
xpts_splines = xlinspace(xdomains, nsegs2);

% compute polynomials
[pcoefs, cvx_status] = utap_learn2(degree_poly, xdomains, ...
				   pt, pairwisecmp);
pcoefs

% check cvx status
k = strfind(cvx_status, 'Solved');
if length(k) < 1
	fprintf('error: cvx_status: %s\n', cvx_status);
end

% Check that umax is equal to 1
umax = utap(pcoefs, xdomains(:,2)')

% compute splines
[xpts_splines, spcoefs,  cvx_status] = utas_learn2(nsegs2, degree_splines, ...
						   degree_continuity, ...
						   xdomains, ...
						   pt, pairwisecmp);
spcoefs

% check cvx status
k = strfind(cvx_status, 'Solved');
if length(k) < 1
	fprintf('error: cvx_status: %s\n', cvx_status);
end

% Check that umax is equal to 1
umax = utas(xpts_splines, spcoefs, xdomains(:,2)')

% Compute utilities with the polynomials and splines
u2 = utap(pcoefs, pt);
u3 = utas(xpts_splines, spcoefs, pt);

% Compute the ranking
ranking2 = compute_ranking(u2);
ranking3 = compute_ranking(u3);
%[ranking'; ranking2'; ranking3'; u'; u2; u3]'

% Compute spearman distance and kendall tau
pspearmand = compute_spearman_distance(ranking, ranking2)
pkendallt = compute_kendall_tau(ranking, ranking2)
sspearmand = compute_spearman_distance(ranking, ranking3)
skendallt = compute_kendall_tau(ranking, ranking3)

% plot UTA piecewise linear functions and polynoms
figure

nplotsperline = 4;
nlines = ceil((ncriteria) / nplotsperline) + 1;
cmap = distinguishable_colors(3);
%cmap = hsv(3);
plots = [];

% plot piecewise linear functions
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

% plot polynomials
plotstr = sprintf('polynomials (%d) - SD: %g - KT: %g ', degree_poly, ...
		  pspearmand, pkendallt);
plotrefs = plot_poly_utilities(pcoefs, xdomains, '-', ...
			       cmap(2, :), plotstr, ...
			       nplotsperline);
plots(2) = plotrefs(1);

% plot splines
plotstr = sprintf('splines (%d) - SD: %g - KT: %g ', degree_splines, ...
		  sspearmand, skendallt);
plotrefs = plot_splines_utilities(spcoefs, xpts_splines, '-', ...
			          cmap(3, :), plotstr, ...
			          nplotsperline);
print_splines_utilities(spcoefs, xpts_splines, 'spline.dat')

plots(3) = plotrefs(1);

% print accuracy
fprintf('\nPolynomials degree: %d\n', degree_poly);
fprintf('Spearman distance: %g\n', pspearmand);
fprintf('Kendall tau: %g\n', pkendallt);

fprintf('\nSplines degree: %d\n', degree_splines);
fprintf('Spearman distance: %g\n', sspearmand);
fprintf('Kendall tau: %g\n', skendallt);

sh = subplot(nlines, nplotsperline, nplotsperline * nlines - 2);
axis off;
legend(sh, plots);
