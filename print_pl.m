function str = print_pl(xpts, uis)

npts = length(xpts);

str = sprintf('(%g %g)', xpts(1), uis(1));
for i = 2:npts
	str = sprintf('%s (%g,%g)', str, xpts(i), uis(i));
end
