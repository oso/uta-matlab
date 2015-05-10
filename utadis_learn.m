function [uis, ucats, cvx_status] = utadis_learn(xdomains, ...
						 ncategories, ...
						 nsegments, ...
						 pt, assignments)

epsilon = 0.00001;
na = size(pt, 1);
ncriteria = size(pt, 2);

nsegmax = max(nsegments)
xpts = zeros(ncriteria, nsegmax + 1);
for i = 1:ncriteria
	npts = nsegments(i) + 1;
	xpts(i, 1:npts) = linspace(xdomains(i, 1), xdomains(i, 2), npts);
end
xpts

cvx_begin
	variable uis(ncriteria, nsegmax + 1) nonnegative;
	variable ucats(ncategories - 1) nonnegative;
	variable aplus(na) nonnegative;
	variable amin(na) nonnegative;

	minimize (sum(aplus) + sum(amin));
	subject to
		for i = 1:na
			ap = pt(i, :);
			assign = assignments(i);

			u = 0;
			for j = 1:ncriteria
				for k = 2:nsegments(j) + 1
					xpt = xpts(j, k);
					if ap(j) <= xpt
						break;
					end
				end

				u = u + uis(j, k - 1);

				xpt2 = xpts(j, k - 1);
				p = (ap(j) - xpt2) / (xpt - xpt2);
				u = u + p * (uis(j, k) - uis(j, k - 1));
			end

			if assign > 1
				0 <= u - ucats(assign - 1) + aplus(i);
			end

			if assign < ncategories
				-epsilon >= u - ucats(assign) - amin(i);
			end
		end

		for j = 1:ncriteria
			uis(j, 1) == 0;

			for k = 2:nsegments(j) + 1
				uis(j, k) >= uis(j, k - 1);
			end
		end

		for i = 1:ncategories-2
			ucats(i) <= ucats(i + 1);
		end

		ucats(ncategories - 1) <= 1;

		umax = 0;
		for j = 1:ncriteria
			umax = umax + uis(j, nsegments(j) + 1);
		end
		umax == 1;
cvx_end
