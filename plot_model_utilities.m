function plotrefs = plot_model_utilities(model, xdomains, mark, color, ...
					 name, nplotsperline)

ncriteria = size(xdomains, 1);
nlines = ceil((ncriteria) / nplotsperline) + 1;

plotrefs = [];
for j = 1:ncriteria
	subplot(nlines, nplotsperline, j);

	hold on;

	x = linspace(xdomains(j,1), xdomains(j,2));
	pt = zeros(length(x), ncriteria);
	pt(:,j) = x;
	[u, ui] = model(pt);
	uval = ui(:,j);

	plotrefs(j) = plot(x, uval, 'Color', color, 'DisplayName', name);

	hold off;
end
