function [xpts, uis] = utarandom(xdomains, nsegs)

ncriteria = size(xdomains, 1);
nsegmax = max(nsegs);

uimax = sort(rand(ncriteria - 1, 1));
uimax(ncriteria) = 1;
uimax(2:ncriteria) = uimax(2:ncriteria) - uimax(1:ncriteria-1);

uis = zeros(ncriteria, nsegmax + 1);
xpts = zeros(ncriteria, nsegmax + 1);

for i = 1:ncriteria
	npts = nsegs(i) + 1;
	xpts(i, 1:npts) = linspace(xdomains(i, 1), xdomains(i, 2), npts);
	uis(i, 1) = 0;
	uis(i, 2:npts) = sort(rand(1, npts - 1));
	uis(i, 1:npts) = uis(i, 1:npts) ./ uis(i, npts) .* uimax(i);
end
