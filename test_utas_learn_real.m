function [spearmand, kendallt, spearmand_gen, kendallt_gen, cvx_optval,
	  cvx_cputime] = ...
		test_utas_learn_real(seed, model, ncriteria, na, nagen, ...
				     nsegments, degree, continuity, plot)

if nargin == 0
	% seed
	seed = 1;

	% model and learning/generalization set size
	model = @m1u;
	na = 100;
	nagen = 1000;

	% parameters of uta-splines
	nsegments = 3;
	degree = 4;
	continuity = 2;
end

rand('seed', seed)
model
na
nagen
nsegments
degree
continuity

xdomains = [0 1; 0 1; 0 1];

% generate perforamnce table for generalization
pt_gen = pt_random(nagen, xdomains);
u_gen = model(pt_gen);

% generate performance table and pairwise comparisons
pt = pt_random(na, xdomains);
u = model(pt);
pairwisecmp = compute_pairwise_relations(u);

% learn marginal utilities
nsegs = repmat([nsegments], 3, 1);
[xpts, pcoefs, cvx_status, cvx_optval, cvx_cputime] = ...
	utas_learn2(nsegs, degree, continuity, xdomains, pt, pairwisecmp);
pcoefs

umax = utas(xpts, pcoefs, xdomains(:,2)')

% compute spearman distance and kendall tau
u2 = utas(xpts, pcoefs, pt);
ranking = compute_ranking(u);
ranking2 = compute_ranking(u2);

spearmand = compute_spearman_distance(ranking, ranking2)
kendallt = compute_kendall_tau(ranking, ranking2)

u2 = utas(xpts, pcoefs, pt_gen);
ranking = compute_ranking(u_gen);
ranking2 = compute_ranking(u2);

spearmand_gen = compute_spearman_distance(ranking, ranking2)
kendallt_gen = compute_kendall_tau(ranking, ranking2)

% plot the marginals
if plot == 0
	return
end

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
