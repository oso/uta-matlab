function pt = pt_random(n, xdomains)

ncriteria = size(xdomains, 1);
pt = rand(n, ncriteria);

xrange = (xdomains(:, 2) - xdomains(:, 1))';
xmin = xdomains(:, 1)';

pt = repmat(xmin, n, 1) + pt .* repmat(xrange, n, 1);
