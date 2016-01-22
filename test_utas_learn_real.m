close all; clear all; clc;

rand('seed', 1);

na = 100;
nagen = 1000;
model = @m2u;

xdomains = [0 1; 0 1; 0 1];

% generate performance table and pairwise comparisons
pt = pt_random(na, xdomains);
u = model(pt);
pairwisecmp = compute_pairwise_relations(u);

% parameters of uta-splines
nsegments = 3
degree = 4
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

rand('seed', 456);
pt = pt_random(nagen, xdomains);
u = model(pt);
u2 = utas(xpts, pcoefs, pt);
ranking = compute_ranking(u);
ranking2 = compute_ranking(u2);

spearmand = compute_spearman_distance(ranking, ranking2)
kendallt = compute_kendall_tau(ranking, ranking2)

% plot the marginals
cmap = hsv(2);
plots = [];

plotstr = 'real';
plotrefs = plot_model_utilities(model, xdomains, '-', cmap(1,:), plotstr, 3);
plots(1) = plotrefs(1);

plotstr = sprintf('nsegs: %d; deg: %d; cont: %d; SD: %g; KT: %g', ...
		  nsegments, degree, continuity, spearmand, kendallt);
plotrefs = plot_splines_utilities(pcoefs, xpts, '-', cmap(2,:), plotstr, 3);
plots(2) = plotrefs(1);

sh = subplot(2, 3, 5);
axis off;
legend(sh, plots);

print_splines_utilities(pcoefs, xpts, 'spline.dat')
