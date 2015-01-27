function y = uta(xdomain, ysteps, x)

nseg  = length(ysteps) - 1;
interval = (xdomain(2) - xdomain(1)) / nseg;

xi = x / interval;
xp = mod(x, interval);
xlow = floor(xi);
xhigh = ceil(xi);

if xlow == xhigh
	y = ysteps(xlow + 1);
else
	y = ysteps(xlow + 1) \
		+ xp / interval * (ysteps(xhigh + 1) - ysteps(xlow + 1));
end
