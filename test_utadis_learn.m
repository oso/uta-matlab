close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 12);

na = 100
ncriteria = 3
ncategories = 3

% domains of the criteria
xdomains = repmat([0 1], ncriteria, 1);

% number of segments
nsegs = repmat([3], ncriteria, 1);

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

% compute polynoms
[xpts2, uis2, ucats2, cvx_status] = utadis_learn(nsegs, xdomains, ...
						 ncategories, ...
						 pt, assignments);

% check cvx status
k = strfind(cvx_status, 'Solved');
if length(k) < 1
	fprintf('error: cvx_status: %s\n', cvx_status);
end

% Check that umax is equal to 1
umax = uta(xpts, uis2, xdomains(:, 2)')

% Assign the alternatives with the polynom
u2 = uta(xpts, uis2, pt);
assignments2 = utasort(ucats2, u2);

% Compute classification accuracy
ca = compute_ca(assignments, assignments2);

% plot UTA piecewise linear functions and polynoms
figure

nplotsperline = 4;
nlines = ceil((ncriteria) / nplotsperline) + 1;
cmap = distinguishable_colors(2)
%cmap = hsv(2);
plots = [];

ustr = sprintf('%g', ucats);
plotstr = sprintf('plinear;  U [%s]', ustr);
plotrefs = plot_pl_utilities(xpts, uis, '-*', cmap(1,:), plotstr, ...
			     nplotsperline);
plots(1) = plotrefs(1);

% print original piecewise linear functions
fprintf('original piecewise linear functions\n');
fprintf('===================================\n');
for j = 1:ncriteria
	str = print_pl(xpts(j,:), uis(j,:));
	fprintf('u_%d: %s\n', j, str);
end
fprintf('U: %s\n', ustr);

ustr = sprintf('%g ', ucats2);
plotstr = sprintf('U [%s]; CA %g', ustr, ca);

plotrefs = plot_pl_utilities(xpts, uis2, '-*',  cmap(2,:), plotstr, ...
			     nplotsperline);
plots(2) = plotrefs(1);

fprintf('\nlearned piecewise linear functions\n');
fprintf('==================================\n');
for j = 1:ncriteria
	str = print_pl(xpts(j,:), uis(j,:));
	fprintf('u_%d: %s\n', j, str);
end
fprintf('U: %s\n', ustr);

% print CA
fprintf('CA: %g\n', ca);

sh = subplot(nlines, nplotsperline, nplotsperline * nlines);
axis off;
legend(sh, plots);
sh = subplot(nlines, nplotsperline, nplotsperline * nlines - 2);
axis off;
legend(sh, plots);
