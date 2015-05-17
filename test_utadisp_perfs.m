function test_utadisp_perfs(nas, ncriterias, ncategories, model, ...
			    degrees_nsegs, nseginit, filename)

if strcmp(model, 'UTADISP')
	colnames = {'NA', 'NCRITERIA', 'NCATEGORIES', 'DEGREE', ...
		    'CAAVG', 'CASTD', 'CAMIN', 'CAMAX', 'CAGENAVG', ...
		    'CAGENSTD', 'CAGENMIN', 'CAGENMAX'};
elseif strcmp(model, 'UTADIS')
	colnames = {'NA', 'NCRITERIA', 'NCATEGORIES', 'NSEGMENTS', ...
		    'CAAVG', 'CASTD', 'CAMIN', 'CAMAX', 'CAGENAVG', ...
		    'CAGENSTD', 'CAGENMIN', 'CAGENMAX'};
else
	error('Invalid model');
end

i = 0;
for na = nas
	for ncriteria = ncriterias
		for ncat = ncategories
			for degree_nseg = degrees_nsegs
				rand('seed', 0);

				na, ncriteria, ncat, degree_nseg
				i = i + 1;
				[tavg, tstd, caavg, castd, camin, camax, ...
				 cagenavg, cagenstd, cagenmin, cagenmax] = ...
					run_one_utap_test(na, ncriteria, ...
							  ncategories, ...
							  model, ...
							  degree_nseg, ...
							  nseginit);

				results(i, :) = [na, ncriteria, ncat, ...
						 degree_nseg, ...
						 tavg, tstd, caavg, castd, ...
						 camin, camax, cagenavg, ...
						 cagenstd, cagenmin, cagenmax];
			end
		end
	end
end

savedata(colnames, results, filename);

end

function [tavg, tstd, caavg, castd, camin, camax, cagenavg, cagenstd, ...
	  cagenmin, cagenmax] = run_one_utap_test(na, ncriteria, ncat, ...
						  model, degree_nseg, ...
						  nseginit)

niterations = 10;
xdomains = repmat([-1 1], ncriteria, 1);
nseginit = repmat([nseginit], ncriteria, 1);

for i = 1:niterations
	% generate random initial UTA functions
	[xpts, uis] = uta_random(xdomains, nseginit);
	ucats = sort(rand(1, ncat - 1));

	% generate random performance table
	pt = pt_random(na, xdomains);

	% compute utilities
	u = uta(xpts, uis, pt);
	assignments = utasort(ucats, u);

	% learn model and compute utility
	if strcmp(model, 'UTADISP')
		tic;
		[pcoefs2, ucats2, cvx_status] = utadisp_learn(degree_nseg, ...
							      xdomains, ...
							      ncat, ...
							      pt, ...
							      assignments);
		t(i) = toc;
		u2 = utap(pcoefs2, pt);
	elseif strcmp(model, 'UTADIS')
		tic;
		nsegs = repmat([degree_nseg], length(xdomains), 1);
		[xpts2, uis2, ucats2, cvx_status] = utadis_learn(nsegs, ...
								 xdomains, ...
								 ncat, ...
								 pt, ...
								 assignments);
		t(i) = toc;
		u2 = uta(xpts2, uis2, pt);
	else
		error('Invalid model')
	end

	% compute ca and auc
	assignments2 = utasort(ucats2, u2);
	ca(i) = compute_ca(assignments, assignments2);

	% perform generalization
	pt = pt_random(10000, xdomains);
	u = uta(xpts, uis, pt);
	if strcmp(model, 'UTADISP')
		u2 = utap(pcoefs2, pt);
	elseif strcmp(model, 'UTADIS')
		u2 = uta(xpts2, uis2, pt);
	else
		error('Invalid model')
	end

	% compute spearman distance and kendall tau
	assignments = utasort(ucats, u);
	assignments2 = utasort(ucats2, u2);
	cagen(i) = compute_ca(assignments, assignments2);
end

tavg = mean(t);
tstd = std(t);
caavg = mean(ca);
castd = std(ca);
camin = min(ca);
camax = max(ca);
cagenavg = mean(cagen);
cagenstd = std(cagen);
cagenmin = min(cagen);
cagenmax = max(cagen);

end
