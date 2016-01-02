function [pcoefs, cvx_status] = utap_learn2(deg, xdomains, pt, ...
					    pairwisecmp)

ncriteria = size(pt, 2);
nsegs = repmat([1], ncriteria, 1);

[xpts, pcoefs, cvx_status] = utas_learn2(nsegs, deg, 0, xdomains, pt, ...
					 pairwisecmp);
pcoefs = pcoefs(:,:,1);
