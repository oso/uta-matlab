function [xpts, pcoefs, ucats, cvx_status] = utadiss_learn(nsegments, deg, ...
							   deg_continuity, ...
							   xdomains, ...
							   ncategories, ...
							   pt, ...
							   assignments)

epsilon = 0.00001;
na = size(pt, 1);
ncriteria = size(pt, 2);

nsegmax = max(nsegments);
xpts = zeros(ncriteria, nsegmax + 1);
for i = 1:ncriteria
	npts = nsegments(i) + 1;
	xpts(i, 1:npts) = linspace(xdomains(i, 1), xdomains(i, 2), npts);
end

n = ceil((deg - 1) / 2) + 1;

cvx_begin
	variable a(deg + 1, ncriteria, nsegmax);
	variable Q(n, n, ncriteria, nsegmax) symmetric;
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

				xpt2 = xpts(j, k - 1);
				u = u + ap(j) .^ (0:deg) * a(:, j, k - 1);
			end

			if assign > 1
				0 <= u - ucats(assign - 1) + aplus(i);
			end

			if assign < ncategories
				-epsilon >= u - ucats(assign) - amin(i);
			end
		end

		for j = 1:ncriteria
			for k = 1:nsegmax
				Q(:, :, j, k) == semidefinite(n);
			end
		end

		Q(:,:,:,:) <= 10;
		Q(:,:,:,:) >= -10;

		l = 1 - n;
		for i = 2:2*n
			for j = 1:ncriteria
				for k = 1:nsegments(j)
					ai = sum(diag(rot90(Q(:, :, j, k)), l));
					if i > length(a(:,j))
						ai == 0;
					else
						ai == (i - 1) * a(i, j, k);
					end
				end
			end

			l = l + 1;
		end

		for i = 1:ncategories-2
			ucats(i) <= ucats(i + 1);
		end

		ucats(ncategories - 1) <= 1;

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
			for l = 1+d:size(a(:, i))
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
