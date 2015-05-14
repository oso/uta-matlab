function test_utap_perfs(nas, ncriterias, model, degrees_nsegs, ...
			 nseginit, filename)

if strcmp(model, 'UTAP')
	colnames = {'NA', 'NCRITERIA', 'DEGREE', 'TAVG', 'TSTD', ...
		    'SDAVG', 'SDSTD', 'KTAVG', 'KTSTD'};
elseif strcmp(model, 'UTA')
	colnames = {'NA', 'NCRITERIA', 'NSEGMENTS', 'TAVG', 'TSTD', ...
		    'SDAVG', 'SDSTD', 'KTAVG', 'KTSTD'};
else
	error('Invalid model')
end

i = 0;
for na = nas
	for ncriteria = ncriterias
		for degree_nseg = degrees_nsegs
			rand('seed', 0);

			na, ncriteria, degrees_nsegs
			i = i + 1;
			[tavg, tstd, sdavg, sdstd, ktavg, ktstd] = ...
				run_one_utap_test(na, ncriteria, ...
						  model, degree_nseg, ...
						  nseginit);

			results(i, :) = [na, ncriteria, degree_nseg, ...
					 tavg, tstd, sdavg, sdstd, ...
					 ktavg, ktstd];
		end
	end
end

savedata(colnames, results, filename);

end

function [tavg, tstd, sdavg, sdstd, ktavg, ktstd] = ...
		run_one_utap_test(na, ncriteria, ...
				  model, degree_nseg, ...
				  nseginit)

niterations = 10;
xdomains = repmat([-1 1], ncriteria, 1);
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
		[u2, t(i)] = learn_and_get_utility_utap(degree_nseg, ...
							xdomains, ...
							pt, pairwisecmp);
	elseif strcmp(model, 'UTA')
		[u2, t(i)] = learn_and_get_utility_uta(degree_nseg, ...
						       xdomains, ...
						       pt, pairwisecmp);
	else
		error('Invalid model')
	end

	% compute spearman distance and kendall tau
	ranking2 = compute_ranking(u2);
	sd(i) = compute_spearman_distance(ranking, ranking2);
	kt(i) = compute_kendall_tau(ranking, ranking2);
end

tavg = mean(t);
tstd = std(t);
sdavg = mean(sd);
sdstd = std(sd);
ktavg = mean(kt);
ktstd = std(kt);

end

function [u, t] = learn_and_get_utility_utap(degree, xdomains, pt, ...
					     pairwisecmp)
tic;
[pcoefs] = utap_learn(degree, xdomains, pt, pairwisecmp);
t = toc;

u = utap(pcoefs, pt);

end

function [u, t] = learn_and_get_utility_uta(nseg, xdomains, pt, ...
					    pairwisecmp)
tic;
[uis] = uta_learn(nseg, xdomains, pt, pairwisecmp);
t = toc;

u = uta(xpts, uis, pt);

end
