close all; clear all; clc;

% cvx precision
% cvx_precision best

% read data from csv file
[ncategories, pt, assignments] = data_get_pt_aa('data/jra_4_categories.csv');

na = size(pt, 1)
ncriteria = size(pt, 2)

% domains of the criteria
%xdomains = repmat([0 1], ncriteria, 1);
xdomains = [min(pt)' max(pt)']

% number of segments
nsegments = [2 3 9]

% degrees of the polynoms
degrees = [3];

% degree of continuity
continuity_degrees = [0 2]

results = cell(length(nsegments), length(degrees), ...
	       length(continuity_degrees), 4);

for i = 1:length(nsegments)
	nsegment = nsegments(i)
	nsegs = repmat([nsegment], ncriteria, 1);

	for j = 1:length(degrees)
		deg = degrees(j)

		for k = 1:length(continuity_degrees)
			continuity_deg = continuity_degrees(k)

			if continuity_deg > deg - 1
				break
			end

			% compute splines
			[xpts, pcoefs, ucats2] = ...
				utadiss_learn2(nsegs, deg, ...
					       continuity_deg, xdomains, ...
					       ncategories, pt, assignments);

			% Assign the alternatives with the polynom
			u2 = utas(xpts, pcoefs, pt);
			assignments2 = utasort(ucats2, u2);

			% Compute classification accuracy
			ca = compute_ca(assignments, assignments2);

			% Store ca, polynoms and category limits
			results(i,j,k,1) = {xpts};
			results(i,j,k,2) = {pcoefs};
			results(i,j,k,3) = {ucats2};
			results(i,j,k,4) = {ca};
		end
	end
end

% plot polynomials
figure

nplotsperline = 4;
nlines = ceil((ncriteria) / nplotsperline) + 1;
%cmap = distinguishable_colors(length(degrees) + 1);
cmap = hsv(length(nsegments) + length(degrees) + ...
	   length(continuity_degrees) + 1);
plots = [];
l = 0;

for i = 1:length(nsegments)
	for j = 1:length(degrees)
		for k = 1:length(continuity_degrees)
			nsegment = nsegments(i);
			deg = degrees(j);
			continuity_deg = continuity_degrees(k);

			l = l + 1;

			xpts = cell2mat(results(i, j, k, 1));
			pcoefs = cell2mat(results(i, j, k, 2));
			ucats2 = cell2mat(results(i, j, k, 3));
			ca = cell2mat(results(i, j, k, 4));

			ustr = sprintf('%g ', ucats2);
			plotstr = sprintf('nsegments %d; degree %d; continuity %d; U [%s]; CA %g', ...
					  nsegment, deg, continuity_deg, ustr, ca);

			plotrefs = plot_splines_utilities(pcoefs, xpts, ...
							  '-', cmap(l,:), ...
							  plotstr, ...
							  nplotsperline);
			plots(l) = plotrefs(1);

			% print degree
			fprintf('\nNsegments: %d; Degree %d; Continuity %d\n', ...
				nsegment, deg, continuity_deg);
			fprintf('=========================================\n');

			% print uvals
			fprintf('U: %s\n', ustr);

			% print CA
			fprintf('CA: %g\n\n', ca);
		end
	end
end

sh = subplot(nlines, nplotsperline, nplotsperline * nlines);
axis off;
legend(sh, plots);
