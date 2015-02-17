function plotrefs = save_poly_utilities(filename, p, xdomains)

ncriteria = size(p, 1);

plot_values = [];
for j = 1:ncriteria
	x = linspace(xdomains(j,1), xdomains(j,2));
	uval = polyval(p(j,:), x);

	plot_values(:, 2*j-1) = x';
	plot_values(:, 2*j) = uval';
end

delete(filename);
fd = fopen(filename, 'a+');

str = sprintf('x%d,u%d', 1, 1);
for j = 2:ncriteria
	str = sprintf('%s,x%d,u%d', str, j, j);
end
fprintf(fd, '%s\n', str);
dlmwrite(filename, plot_values, '-append');
fprintf(fd, '\n');
fclose(fd);
