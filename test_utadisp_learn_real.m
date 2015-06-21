close all; clear all; clc;

% cvx precision
% cvx_precision best

% init pseudo-random number generator
rand('seed', 123);

na = 100
ncriteria = 5
ncategories = 3

x = -[300 450 600];
y = [0.4 0.30 0];
f1 = polyfit(x, y, 2);
f1 = f1 ./ polyval(f1, -300) * 0.4
%x1 = -300:-1:-600;
%y1 = polyval(f1, x1);
%plot(x1, y1, x, y, 'b*');

x = -[500:10:800 1000:10:1200 1400:10:1500];
y = [0.41:-0.001:0.38 0.21:-0.001:0.19 0.02:-0.002:0];
f2 = polyfit(x, y, 15);
f2 = f2 ./ polyval(f2, -500) * 0.4
%x2 = -500:-1:-1500;
%y2 = polyval(f2, x2);
%plot(x2, y2, x, y, 'b*');

x = [50 100 150];
y = [0 0.15 0.2];
f3 = polyfit(x, y, 2);
f3 = f3 ./ polyval(f3, 150) * 0.2
%x3 = 50:1:150;
%y3 = polyval(f3, x3);
%plot(x3, y3, 'b-');

uf = zeros(3, 16);
uf(1,17-length(f1):16) = f1;
uf(2,17-length(f2):16) = f2;
uf(3,17-length(f3):16) = f3;

xdomains = [-600 -300; -1500 -500; 50 150]

% generate category thresholds
%ucats = sort(rand(1, ncategories - 1))
ucats = linspace(0, 1, ncategories + 1);
ucats = ucats(2:ncategories);

% generate random performance table
pt = pt_random(na, xdomains);

% assign examples
u = utap(uf, pt);
assignments = utasort(ucats, u);
oo;

% compute assignments
u = uta(xpts, uis, pt);
assignments = utasort(ucats, u);

% degrees of the polynoms
degrees = [4];

results = cell(3);

for i = 1:length(degrees)
	deg = degrees(i)

	% compute polynoms
	[pcoefs, ucats2] = utadisp_learn(deg, xdomains, ncategories, ...
					 pt, assignments);

	% Check that umax is equal to 1
	umax = 0;
	for j = 1:ncriteria
		umax = umax + polyval(pcoefs(j,:), xdomains(j, 2));
	end
	umax

	% Assign the alternatives with the polynom
	u2 = utap(pcoefs, pt);
	assignments2 = utasort(ucats2, u2);

	% Compute classification accuracy
	ca = compute_ca(assignments, assignments2);

	% Store ca, polynoms and category limits
	results(i,1) = {pcoefs};
	results(i,2) = {ucats2};
	results(i,3) = {ca};
end

% plot UTA piecewise linear functions and polynoms
figure

nplotsperline = 4;
nlines = ceil((ncriteria) / nplotsperline) + 1;
%cmap = distinguishable_colors(length(degrees) + 1)
cmap = hsv(length(degrees) + 1);
plots = [];

ustr = sprintf('%g', ucats);
plotstr = sprintf('plinear;  U [%s]', ustr);
plotrefs = plot_pl_utilities(xpts, uis, '-*', cmap(1,:), plotstr, ...
			     nplotsperline);
plots(1) = plotrefs(1);

% print piecewise linear functions
fprintf('piecewise linear functions\n');
fprintf('==========================\n\n');
for j = 1:ncriteria
	str = print_pl(xpts(j,:), uis(j,:));
	fprintf('u_%d: %s\n', j, str);
	fprintf('U: %s\n', ustr);
end

for i = 1:length(degrees)
	deg = degrees(i);

	pcoefs = cell2mat(results(i, 1));
	ucats2 = cell2mat(results(i, 2));
	ca = cell2mat(results(i, 3));

	ustr = sprintf('%g ', ucats2);
	plotstr = sprintf('degree %d; U [%s]; CA %g', deg, ustr, ca);

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

	% print uvals
	fprintf('U: %s\n', ustr);

	% print CA
	fprintf('CA: %g\n', ca);
end

sh = subplot(nlines, nplotsperline, nplotsperline * nlines);
axis off;
legend(sh, plots);
sh = subplot(nlines, nplotsperline, nplotsperline * nlines - 2);
axis off;
legend(sh, plots);
