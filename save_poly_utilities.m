function plotrefs = save_poly_utilities(filename, p, xdomains)

ncriteria = size(p, 1);

plot_values = []
for j = 1:ncriteria
	x = linspace(xdomains(j,1), xdomains(j,2));
	uval = polyval(p(j,:), x);

	plot_values(:, 2*j-1) = x';
	plot_values(:, 2*j) = uval';
end

delete(filename)
fd = fopen(filename, 'a+');
for j = 1:

dlmwrite(filename, plot_values, '-append');
fprintf(fd, '\n');
fclose(fd);
