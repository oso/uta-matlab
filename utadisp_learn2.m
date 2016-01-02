function [pcoefs, ucats, cvx_status] = utadisp_learn2(deg, xdomains, ...
						      ncategories, pt, ...
						      assignments)

ncriteria = size(pt, 2);
nsegs = repmat([1], ncriteria, 1);
[xpts, pcoefs, ucats, cvx_status] = utadiss_learn2(nsegs, deg, 0, xdomains, ...
						   ncategories, pt, assignments);

pcoefs = pcoefs(:,:,1);
