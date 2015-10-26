function [pcoefs, cvx_status] = utas_learn2(nsegments, deg, deg_continuity, ...
					    xdomains, pt, pairwisecmp)

epsilon = 0.00001;
na = size(pairwisecmp, 1);
ncriteria = size(pt, 2);

nsegmax = max(nsegments);
xpts = zeros(ncriteria, nsegmax + 1);
for i = 1:ncriteria
	npts = nsegments(i) + 1;
	xpts(i, 1:npts) = linspace(xdomains(i, 1), xdomains(i, 2), npts);
end

n = ceil(deg / 2 + 1);

cvx_begin
	variable a(deg + 1, ncriteria, nsegmax);
	variable Q(n, n, ncriteria, nsegmax) symmetric;
	variable R(n, n, ncriteria, nsegmax) symmetric;
	variable aplus(na) nonnegative;
	variable amin(na) nonnegative;

	minimize (sum(aplus) + sum(amin));
	subject to
		for i = 1:na
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

				xpt2 = xpts(j, k - 1);
				u1 = u1 + ap1(j) .^ (0:deg) * a(:, j, k - 1);
			end

			u2 = 0;
			for j = 1:ncriteria
				for k = 2:nsegments(j) + 1
					xpt = xpts(j, k);
					if ap2(j) <= xpt
						break;
					end
				end

				xpt2 = xpts(j, k - 1);
				u2 = u2 + ap2(j) .^ (0:deg) * a(:, j, k - 1);
			end

			if pairwisecmp(i, 3) > 0
				u1 - u2 + aplus(i) - amin(i) >= epsilon
			elseif pairwisecmp(i, 3) < 0
				u2 - u1 + aplus(i) - amin(i) >= epsilon
			elseif pairwisecmp(i, 3) == 0
				u2 - u1 + aplus(i) - amin(i) == 0
			end
		end

		for j = 1:ncriteria
			for k = 1:nsegmax
				Q(:, :, j, k) == semidefinite(n);
				R(:, :, j, k) == semidefinite(n);
			end
		end

		l = 1 - deg;
		for i = 2:2*deg+1
			for j = 1:ncriteria
				for k = 1:nsegments(j)
					ai = - xpts(j, k) * sum(diag(rot90(Q(:, :, j, k)), l)) ...
					     + xpts(j, k + 1) * sum(diag(rot90(R(:, :, j, k)), l));

					if i > 2
						ai = ai + sum(diag(rot90(Q(:, :, j, k)), l - 1)) ...
						        - sum(diag(rot90(R(:, :, j, k)), l - 1));
					end

					if i > length(a(:,j))
						ai == 0;
					else
						ai == (i - 1) * a(i, j, k);
					end
				end
			end

			l = l + 1;
		end

		for j = 1:ncriteria
			xdomains(j, 1).^(0:deg)*a(:, j, 1) == 0;
		end

		umax = 0;
		for j = 1:ncriteria
			umax = umax + xdomains(j, 2).^(0:deg)*a(:, j, nsegments(j));
		end
		umax == 1;

		for d = 0:deg_continuity
			z = [];
			for l = 1+d:size(a(:, 1, 1), 1)
				z(l - d) = factorial(l - 1) / factorial(l - 1 - d);
			end

			for j = 1:ncriteria
				for i = 2:nsegments(j)
					x1 = z .* xpts(j, i) .^ (0:deg-d) * a(d + 1:deg + 1, j, i);
					x2 = z .* xpts(j, i) .^ (0:deg-d) * a(d + 1:deg + 1, j, i - 1);

					x1 == x2;
				end
			end
		end
cvx_end

for k = 1:nsegmax
	pcoefs(:,:,k) = fliplr(a(:,:,k)');
end

pcoefs;
