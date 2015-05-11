nas = 50:50:500
ncriteria = 5
ncat = 2
deg = 5

niterations = 100

xdomains = repmat([-1 1], ncriteria, 1);
nsegs = repmat([10], ncriteria, 1);

% generate random UTA functions
[xpts, uis] = uta_random(xdomains, nsegs);

tavg = [];
for ina = 1:length(nas)
	na = nas(ina)

	t = [];
	for i = 1:niterations
		% generate random performance table
		pt = pt_random(na, xdomains);

		% compute utilities
		u = uta(xpts, uis, pt);
		pairwisecmp = compute_pairwise_relations(u);

		% compute polynoms
		tic;
		[pcoefs] = utap_learn(deg, xdomains, pt, pairwisecmp);
		t(i) = toc;
	end

	tavg(ina) = mean(t);
	tstd(ina) = std(t);
end

for ina = 1:length(nas)
	fprintf('%d\t%g\t%g\n', nas(ina), tavg(ina), tstd(ina));
end
