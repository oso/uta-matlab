close all; clear all; clc;

rand('seed', 123);

na = 50;

xdomains = [0 1; 0 1; 0 1];

% generate 3 polynomials
x = [0 0.5 1];
y = [0 0.1 0.4]
f1 = polyfit(x, y, 2);
f1 = f1 ./ polyval(f1, 1) * 0.4

x = [0:0.01:0.1 0.3:0.01:0.5 0.7:0.01:1];
y = [0:0.002:0.02 0.19:0.001:0.21 0.38:0.001:0.41];
f2 = polyfit(x, y, 15);
f2 = f2 ./ polyval(f2, 1) * 0.4

x = [0 0.5 1]
y = [0 0.15 0.2]
f3 = polyfit(x, y, 2);
f3 = f3 ./ polyval(f3, 1) * 0.2

uf = zeros(3, 16);
uf(1,17-length(f1):16) = f1;
uf(2,17-length(f2):16) = f2;
uf(3,17-length(f3):16) = f3;

% generate performance table and pairwise comparisons
pt = pt_random(na, xdomains);
u = utap(uf, pt);
pairwisecmp = compute_pairwise_relations(u);

% parameters of uta-splines
nsegments = 3
degree = 5
continuity = 2

% learn marginal utilities
nsegs = repmat([nsegments], 3, 1);
[xpts, pcoefs, cvx_status] = utas_learn2(nsegs, degree, continuity, ...
					 xdomains, pt, pairwisecmp);
pcoefs

umax = utas(xpts, pcoefs, xdomains(:,2)')

u2 = utas(xpts, pcoefs, pt);

% compute spearman distance and kendall tau
ranking = compute_ranking(u);
ranking2 = compute_ranking(u2);

spearmand = compute_spearman_distance(ranking, ranking2)
kendallt = compute_kendall_tau(ranking, ranking2)

% plot the marginals
cmap = hsv(2);
plots = [];

plotstr = 'real';
plotrefs = plot_poly_utilities(uf, xdomains, '-', cmap(1,:), plotstr, 3);
plots(1) = plotrefs(1);

plotstr = sprintf('nsegs: %d; deg: %d; cont: %d; SD: %g; KT: %g', ...
		  nsegments, degree, continuity, spearmand, kendallt);
plotrefs = plot_splines_utilities(pcoefs, xpts, '-', cmap(2,:), plotstr, 3);
plots(2) = plotrefs(1);

sh = subplot(2, 3, 5);
axis off;
legend(sh, plots);
