function plotrefs = plot_pl_utilities(xpts, uis, mark, color, ...
				      name, nplotsperline)

ncriteria = size(xpts, 1);
nlines = ceil((ncriteria) / nplotsperline) + 1;

plotrefs = [];
for j = 1:ncriteria
	subplot(nlines, nplotsperline, j);

	hold on;

	plotrefs(j) = plot(xpts(j,:), uis(j,:), mark, 'Color', color, ...
			   'DisplayName', name);

	hold off;
end
