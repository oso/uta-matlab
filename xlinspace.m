function [xpts] = xlinspace(xdomains, nsegs)

ncriteria = size(xdomains, 1);
nsegmax = max(nsegs);
xpts = zeros(ncriteria, nsegmax + 1);

for i = 1:ncriteria
	npts = nsegs(i) + 1;
	xpts(i, 1:npts) = linspace(xdomains(i, 1), xdomains(i, 2), npts);
end
