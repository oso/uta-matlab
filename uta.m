function u = uta(xdomain, ui, x)

nseg  = length(ui) - 1;
xint = (xdomain(2) - xdomain(1)) / nseg;

xi = x / xint;
xp = mod(x, xint);
xlow = floor(xi);
xhigh = ceil(xi);

if xlow == xhigh
	u = ui(xlow + 1);
else
	u = ui(xlow + 1) + xp / xint * (ui(xhigh + 1) - ui(xlow + 1));
end
