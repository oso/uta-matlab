function [xpts, uis, cvx_status] = uta_learn(nsegments, xdomains, ...
					     pt, pairwisecmp)

epsilon = 0.00001;
na = size(pt, 1);
ncriteria = size(pt, 2);

nsegmax = max(nsegments);
xpts = zeros(ncriteria, nsegmax + 1);
for i = 1:ncriteria
	npts = nsegments(i) + 1;
	xpts(i, 1:npts) = linspace(xdomains(i, 1), xdomains(i, 2), npts);
end

cvx_begin
	variable uis(ncriteria, nsegmax + 1) nonnegative;
	variable aplus(na) nonnegative;
	variable amin(na) nonnegative;

	minimize (sum(aplus) + sum(amin));
	subject to
		for i = 1:size(pairwisecmp, 1)
			i1 = pairwisecmp(i, 1);
			i2 = pairwisecmp(i, 2);

			ap1 = pt(i1, :);
			ap2 = pt(i2, :);

			u1 = 0;
			for j = 1:ncriteria
				for k = 2:nsegments(j) + 1
					xpt = xpts(j, k);
					if ap1(j) <= xpt
						break;
					end
				end

				u1 = u1 + uis(j, k - 1);

				xpt2 = xpts(j, k - 1);
				p = (ap1(j) - xpt2) / (xpt - xpt2);
				u1 = u1 + p * (uis(j, k) - uis(j, k - 1));
			end

			u2 = 0;
			for j = 1:ncriteria
				for k = 2:nsegments(j) + 1
					xpt = xpts(j, k);
					if ap2(j) <= xpt
						break;
					end
				end

				u2 = u2 + uis(j, k - 1);

				xpt2 = xpts(j, k - 1);
				p = (ap2(j) - xpt2) / (xpt - xpt2);
				u2 = u2 + p * (uis(j, k) - uis(j, k - 1));
			end

			if pairwisecmp(i, 3) > 0
				u1 - u2 + aplus(i1) - amin(i2) >= epsilon
			elseif pairwisecmp(i, 3) < 0
				u2 - u1 + aplus(i2) - amin(i1) >= epsilon
			elseif pairwisecmp(i, 3) == 0
				u2 - u1 + aplus(i2) - amin(i1) == 0
			end
		end

		for j = 1:ncriteria
			uis(j, 1) == 0;

			for k = 2:nsegments(j) + 1
				uis(j, k) >= uis(j, k - 1);
			end
		end

		umax = 0;
		for j = 1:ncriteria
			umax = umax + uis(j, nsegments(j) + 1);
		end
		umax == 1;
cvx_end
