nas = 50:50:500
ncriteria = 5
ncat = 2
deg = 5

xdomains = repmat([-1 1], ncriteria, 1);
nsegs = repmat([10], ncriteria, 1);

% generate random UTA functions
[xpts, uis] = uta_random(xdomains, nsegs);

% generate category thresholds
%ucats = sort(rand(1, ncategories - 1))
ucats = linspace(0, 1, ncategories + 1);
ucats = ucats(2:ncategories);

t = [];
for ina = 1:length(nas)
	na = nas(ina)

	% generate random performance table
	pt = pt_random(na, xdomains);

	% compute assignments
	u = uta(xpts, uis, pt);
	assignments = utasort(ucats, u);

	% compute polynoms
	tic;
	[pcoefs, ucats2] = utadisp_learn(deg, xdomains, ncategories, ...
					 pt, assignments);
	t(ina) = toc;

	% print computing time
end

for ina = 1:length(nas)
	na = nas(ina);
	tp = t(ina);
	fprintf('%d %g\n', na, tp);
end
