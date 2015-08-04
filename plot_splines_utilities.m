function plotrefs = plot_slines_utilities(p, xpts, mark, color, ...
					  name, nplotsperline)

ncriteria = size(p, 1);
nlines = ceil((ncriteria) / nplotsperline) + 1;

plotrefs = [];
for j = 1:ncriteria
	subplot(nlines, nplotsperline, j);

	hold on;

	for k = 1:size(xpts, 2)-1
		x = linspace(xpts(j, k), xpts(j, k + 1));
		uval = polyval(p(j,:,k), x);
		plotrefs(j) = plot(x, uval, '-', 'Color', color, 'DisplayName', name);
		plot([xpts(j, k) xpts(j, k + 1)], [uval(1) uval(end)], '*', 'Color', color);
	end

	hold off;
end
