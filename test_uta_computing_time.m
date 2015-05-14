function test_uta_computing_time(nas, ncriteria, deg, nseg, fileprefix)

niterations = 100

xdomains = repmat([-1 1], ncriteria, 1);
nsegs = repmat([nseg], ncriteria, 1);

% generate random UTA functions
[xpts, uis] = uta_random(xdomains, nsegs);

tavg = [];
for ina = 1:length(nas)
	na = nas(ina)

	t = [];
	t2 = [];
	for i = 1:niterations
		% generate random performance table
		pt = pt_random(na, xdomains);

		% compute utilities
		u = uta(xpts, uis, pt);
		pairwisecmp = compute_pairwise_relations(u);

		% compute polynomials
		tic;
		[pcoefs] = utap_learn(deg, xdomains, pt, pairwisecmp);
		t(i) = toc;

		% compute piecewise linear functions
		tic;
		[uis] = uta_learn(nsegs, xdomains, pt, pairwisecmp);
		t2(i) = toc;
	end

	tavg(ina) = mean(t);
	tstd(ina) = std(t);
	t2avg(ina) = mean(t2);
	t2std(ina) = std(t2);
end

filename = sprintf('%s-%d-%d.dat', fileprefix, ncriteria, deg);
savedata({'UTAP_AVG', 'UTAP_STD', 'UTA_AVG', 'UTA_STD'}, ...
	 [tavg' tstd' t2avg' t2std'], filename);
