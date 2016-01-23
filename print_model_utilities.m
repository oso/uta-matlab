function print_model_utilities(model, xdomains, file)

ncriteria = size(xdomains, 1);

for j = 1:ncriteria
	index = 2 * j - 1;

	x = linspace(xdomains(j,1), xdomains(j,2));
	pt = zeros(length(x), ncriteria);
	pt(:,j) = x';
	[u, ui] = model(pt);
	index
	results(:, index:index+1) = [x' ui(:,j)];

end

csvwrite(file, results)
