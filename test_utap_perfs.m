function test_utap_perfs(nas, ncriterias, model, nsegs, degrees, ...
			 nseginit, filename)

colnames = {'NA', 'NCRITERIA', 'NSEGMENTS', 'DEGREE', 'TAVG', 'TSTD', ...
	    'SDAVG', 'SDSTD', 'SDMIN', 'SDMAX', ...
	    'KTAVG', 'KTSTD', 'KTMIN', 'KTMAX', ...
	    'SDGENAVG', 'SDGENSTD', 'SDGENMIN', 'SDGENMAX', ...
	    'KTGENAVG', 'KTGENSTD', 'KTGENMIN', 'KTGENMAX'};
i = 0;
for na = nas
	for ncriteria = ncriterias
		for nseg = nsegs
			for degree = degrees
				rand('seed', 0);

				na, ncriteria, nsegs, degrees
				i = i + 1;
				[tavg, tstd, sdavg, sdstd, sdmin, sdmax, ...
				 ktavg, ktstd, ktmin, ktmax, ...
				 sdgenavg, sdgenstd, sdgenmin, sdgenmax, ...
				 ktgenavg, ktgenstd, ktgenmin, ktgenmax] = ...
					run_one_utap_test(na, ncriteria, ...
							  model, nseg, ...
							  degree, nseginit);

				results(i, :) = [na, ncriteria, nseg, ...
						 degree, tavg, tstd, ...
						 sdavg, sdstd, sdmin, sdmax, ...
						 ktavg, ktstd, ktmin, ktmax, ...
						 sdgenavg, sdgenstd, sdgenmin, ...
						 sdgenmax, ktgenavg, ktgenstd, ...
						 ktgenmin, ktgenmax];
			end
		end
	end
end

savedata(colnames, results, filename);

end

function [tavg, tstd, sdavg, sdstd, sdmin, sdmax, ktavg, ktstd, ktmin, ...
	  ktmax, sdgenavg, sdgenstd, sdgenmin, sdgenmax, ...
	  ktgenavg, ktgenstd, ktgenmin, ktgenmax] = ...
		run_one_utap_test(na, ncriteria, model, nseg, degree, ...
				  nseginit)

niterations = 10;
xdomains = repmat([0 1], ncriteria, 1);
nseginit = repmat([nseginit], ncriteria, 1);

for i = 1:niterations
	% generate random initial UTA functions
	[xpts, uis] = uta_random(xdomains, nseginit);

	% generate random performance table
	pt = pt_random(na, xdomains);

	% compute utilities
	u = uta(xpts, uis, pt);

	pairwisecmp = compute_pairwise_relations(u);
	ranking = compute_ranking(u);

	% learn model and compute utility
	if strcmp(model, 'UTAP')
		tic;
		[pcoefs2] = utap_learn2(degree, xdomains, pt, pairwisecmp);
		t(i) = toc;

		u2 = utap(pcoefs2, pt);
	elseif strcmp(model, 'UTAS')
		nsegs = repmat([nseg], length(xdomains), 1);

		tic;
		[xpts2, pcoefs2] = utas_learn2(nsegs, degree, 2, xdomains, pt, pairwisecmp);
		t(i) = toc;

		u2 = utas(xpts2, pcoefs2, pt);
	elseif strcmp(model, 'UTA')
		nsegs = repmat([nseg], length(xdomains), 1);

		tic;
		[xpts2, uis2] = uta_learn(nsegs, xdomains, pt, pairwisecmp);
		t(i) = toc;

		u2 = uta(xpts, uis, pt);
	else
		error('Invalid model')
	end

	% compute spearman distance and kendall tau
	ranking2 = compute_ranking(u2);
	[ranking'; ranking2'; u'; u2']'

	sd(i) = compute_spearman_distance(ranking, ranking2)
	kt(i) = compute_kendall_tau(ranking, ranking2)

	% perform generalization
	pt = pt_random(2000, xdomains);
	u = uta(xpts, uis, pt);
	if strcmp(model, 'UTAP')
		u2 = utap(pcoefs2, pt);
	elseif strcmp(model, 'UTAS')
		u2 = utas(xpts2, pcoefs2, pt);
	elseif strcmp(model, 'UTA')
		u2 = uta(xpts2, uis2, pt);
	else
		error('Invalid model')
	end

	% compute spearman distance and kendall tau
	ranking = compute_ranking(u);
	ranking2 = compute_ranking(u2);
	sdgen(i) = compute_spearman_distance(ranking, ranking2)
	ktgen(i) = compute_kendall_tau(ranking, ranking2)
end

tavg = mean(t);
tstd = std(t);
sdavg = mean(sd);
sdstd = std(sd);
sdmin = min(sd);
sdmax = max(sd);
ktavg = mean(kt);
ktstd = std(kt);
ktmin = min(kt);
ktmax = max(kt);
sdgenavg = mean(sdgen);
sdgenstd = std(sdgen);
sdgenmin = min(sdgen);
sdgenmax = max(sdgen);
ktgenavg = mean(ktgen);
ktgenstd = std(ktgen);
ktgenmin = min(ktgen);
ktgenmax = max(ktgen);

end
