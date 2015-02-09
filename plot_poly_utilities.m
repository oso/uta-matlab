function plotrefs = plot_poly_utilities(p, xdomains, mark, color, ...
					name, nplotsperline)

ncriteria = size(p, 1);
nlines = ceil((ncriteria) / nplotsperline) + 1;

plotrefs = [];
for j = 1:ncriteria
	subplot(nlines, nplotsperline, j);

	hold on;

	x = xdomains(j,1):0.001:xdomains(j,2);
	uval = polyval(p(j,:), x);

	plotrefs(j) = plot(x, uval, 'Color', color, 'DisplayName', name);

	hold off;
end
