function print_splines_utilities(p, xpts, file)

ncriteria = size(p, 1);

results = []
for j = 1:ncriteria
	xs = []
	uval = []
	for k = 1:size(xpts, 2)-1
		x = linspace(xpts(j, k), xpts(j, k + 1));
		uval = [uval polyval(p(j,:,k), x)];
		xs = [xs; x']
	end

	results = [results xs uval'];
end

csvwrite(file, results)
