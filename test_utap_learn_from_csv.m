close all; clear all; clc;

% cvx precision
% cvx_precision best

% read data from csv file
[ncategories, pt, assignments] = data_get_pt_aa('data/swd_4_categories.csv');

na = size(pt, 1)
ncriteria = size(pt, 2)

% domains of the criteria
%xdomains = repmat([0 1], ncriteria, 1);
xdomains = [min(pt)' max(pt)']

% degrees of the polynoms
degrees = [4];

results = cell(3);

for i = 1:length(degrees)
	deg = degrees(i)

	% compute polynoms
	[pcoefs, ucats2] = utap_learn(deg, xdomains, ncategories, pt, ...
				      assignments);

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
	assign_diff = assignments - assignments2;
	errors = size(find(assign_diff > 0), 1);
	ca = (na - errors) / na;

	% Store ca, polynoms and category limits
	results(i,1) = {pcoefs};
	results(i,2) = {ucats2};
	results(i,3) = {ca};
end

% plot UTA piecewise linear functions and polynoms
figure

nsubx = 4;
nsuby = ceil((ncriteria) / nsubx) + 1;
cmap = distinguishable_colors(length(degrees) + 1);
%cmap = hsv(length(degrees) + 1);
plots = [];

pcoefs
for i = 1:length(degrees)
	deg = degrees(i);
	fprintf('\nDegree %d\n', deg);

	for j = 1:ncriteria
		subplot(nsuby, nsubx, j);

		hold on;
		axis on;

		pcoefs = cell2mat(results(i, 1));
		ucats2 = cell2mat(results(i, 2));
		ca = cell2mat(results(i, 3));

		x = xdomains(j,1):0.001:xdomains(j,2);
		uval = polyval(pcoefs(j,:), x);

		ustr = sprintf('%g ', ucats2);
		plotstr = sprintf('degree %d; U [%s]; CA %g', deg, ustr, ca);

		plots(i) = plot(x, uval, 'Color', cmap(i+1,:), ...
				  'DisplayName', plotstr);

		fprintf(' %d: %g', j, pcoefs(j, end));
		for d = 1:deg
			coef = pcoefs(j, end - d);
			if coef >= 0
				fprintf(' + ');
			else
				fprintf(' - ');
			end
			fprintf('%g*x^%d', abs(coef), d);
		end
		fprintf('\n');

		hold off;
	end
end

sh = subplot(nsuby, nsubx, nsubx * nsuby);
axis off;
legend(sh, plots);
