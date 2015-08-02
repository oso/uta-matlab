ap1 = [0.25 0.4];
ap2 = [0.75 0.7];
pt = [ap1; ap2]

na = size(pt, 1);

xdomain = [0 1];
nsegments = 4;
npts = nsegments + 1;
xpts = linspace(xdomain(1), xdomain(2), npts);

deg = 3;

cvx_begin
	variable a(deg + 1, nsegments);
	variable Q(deg, deg, nsegments);
	variable aplus(na) nonnegative;
	variable amin(na) nonnegative;

	minimize (sum(aplus) + sum(amin));
	subject to
		for i = 1:na
			ap = pt(i, :);

			for k = 1:nsegments
				if ap(1) <= xpts(k + 1)
					break;
				end
			end

			u = ap(1).^(0:deg) * a(:, k);

			u + aplus(i) - amin(i) == ap(2);
		end

		for k = 1:nsegments
			Q(:, :, k) == semidefinite(deg);
		end

		xdomain(1).^(0:deg) * a(:, 1) == 0;
		xdomain(2).^(0:deg) * a(:, nsegments) == 1;

		for d = 0:deg-1
			z = [];
			for l = 1+d:size(a(:, i))
				z(l - d) = factorial(l - 1) / factorial(l - 1 - d);
			end

			for i = 2:nsegments
				x1 = z .* xpts(i) .^ (0:deg-d) * a(d + 1:deg + 1, i);
				x2 = z .* xpts(i) .^ (0:deg-d) * a(d + 1:deg + 1, i - 1);

				x1 == x2;
			end
		end

%		for i = 2:nsegments
%			xpts(i).^(0:deg) * a(:, i) == ...
%				xpts(i).^(0:deg) * a(:, i - 1);
%		end

		l = 1 - deg;
                for i = 2:2*deg
			for k = 1:nsegments
				ai = sum(diag(rot90(Q(:, :, k)), l));
				if i > length(a(:,k))
					ai == 0;
				else
					ai == (i - 1) * a(i, k);
				end
                        end

			l = l + 1;
		end
cvx_end

pcoefs = fliplr(a')

polyval(pcoefs(1, :), 0.25)
polyval(pcoefs(2, :), 0.75)

polyval(pcoefs(1, :), 0)
for i = 2:nsegments
	polyval(pcoefs(i, :), xpts(i))
	polyval(pcoefs(i - 1, :), xpts(i))
end
polyval(pcoefs(nsegments, :), 1)

pcoefs
xpts
for i = 1:nsegments
	x = linspace(xpts(i), xpts(i + 1));
	y = polyval(pcoefs(i, :), x);

	hold on;
	plot(x, y);
	hold off;
end
