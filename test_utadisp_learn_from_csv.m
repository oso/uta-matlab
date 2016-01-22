close all; clear all; clc;

% cvx precision
% cvx_precision best

% read data from csv file
[ncategories, pt, assignments] = data_get_pt_aa('data/cev_4_categories.csv');

%pt = pt(1:25,:)
%assignments = assignments(1:25,:)
%[pt assignments]

na = size(pt, 1)
ncriteria = size(pt, 2)

% domains of the criteria
%xdomains = repmat([0 1], ncriteria, 1);
xdomains = [min(pt)' max(pt)']

% degrees of the polynoms
degrees = [3 5];

results = cell(3);

for i = 1:length(degrees)
	deg = degrees(i)

	% compute polynoms
	[pcoefs, ucats2] = utadisp_learn2(deg, xdomains, ncategories, ...
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

	confusion_table(assignments, assignments2)
end


% plot polynomials
figure

nplotsperline = 4;
nlines = ceil((ncriteria) / nplotsperline) + 1;
%cmap = distinguishable_colors(length(degrees) + 1);
cmap = hsv(length(degrees) + 1);
plots = [];

for i = 1:length(degrees)
	deg = degrees(i);

	pcoefs = cell2mat(results(i, 1));
	ucats2 = cell2mat(results(i, 2));
	ca = cell2mat(results(i, 3));

	ustr = sprintf('%g ', ucats2);
	plotstr = sprintf('degree %d; U [%s]; CA %g', deg, ustr, ca);

	plotrefs = plot_poly_utilities(pcoefs, xdomains, '-', ...
				       cmap(i,:), plotstr, ...
				       nplotsperline);
	plots(i) = plotrefs(1);

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
