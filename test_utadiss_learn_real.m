close all; clear all; clc;

rand('seed', 123);

na = 50;
ncategories = 10;

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

% generate performance table and assignments
pt = pt_random(na, xdomains);
u = utap(uf, pt);
ucats = linspace(0, 1, ncategories + 1);
ucats = ucats(2:ncategories);
assignments = utasort(ucats, u);

% parameters of uta-splines
nsegments = 1
degree = 3
continuity = 2

% learn marginal utilities
nsegs = repmat([nsegments], 3, 1);
[xpts, pcoefs, ucats2, cvx_status] = utadiss_learn2(nsegs, degree, ...
						    continuity, xdomains, ...
						    ncategories, pt, ...
						    assignments);
pcoefs

umax = utas(xpts, pcoefs, xdomains(:,2)')

u2 = utas(xpts, pcoefs, pt);

% compute classification accuracy
assignments2 = utasort(ucats2, u2);
ca = compute_ca(assignments, assignments2);

% plot the marginals
cmap = hsv(2);
plots = [];

plotstr = 'real';
plotrefs = plot_poly_utilities(uf, xdomains, '-', cmap(1,:), plotstr, 3);
plots(1) = plotrefs(1);

plotstr = sprintf('nsegs: %d; deg: %d; cont: %d; CA: %g', ...
		  nsegments, degree, continuity, ca);
plotrefs = plot_splines_utilities(pcoefs, xpts, '-', cmap(2,:), plotstr, 3);
plots(2) = plotrefs(1);

sh = subplot(2, 3, 5);
axis off;
legend(sh, plots);
