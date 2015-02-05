function [pcoefs, ucats] = utap_learn(deg, xdomains, ncategories, pt, ...
				      assignments)

epsilon = 0.00001;
na = size(pt, 1);
ncriteria = size(pt, 2);

n = ceil(deg / 2 + 1);

cvx_begin
	variable a(deg + 1, ncriteria);
	variable Q(n, n, ncriteria) symmetric;
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
				u = u + ap(j).^(0:deg)*a(:, j);
			end

			if assign > 1
				0 <= u - ucats(assign - 1) + aplus(i);
			end

			if assign < ncategories
				-epsilon >= u - ucats(assign) - amin(i);
			end
		end

		for j = 1:ncriteria
			Q(:, :, j) == semidefinite(n);
		end

		for j = 1: ncriteria
			xdomains(j, 1).^(0:deg)*a(:,j) == 0;
		end

		umax = 0;
		for j = 1: ncriteria
			umax = umax + xdomains(j, 2).^(0:deg)*a(:,j);
		end
		umax == 1;

		k = 1 - n;
		for i = 2:2*n
			for j = 1:ncriteria
				ai = sum(diag(rot90(Q(:, :, j)), k));
				if i > length(a(:,j))
					ai == 0;
				else
					ai == (i - 1) * a(i, j);
				end
			end

			k = k + 1;
		end
cvx_end

pcoefs = fliplr(a');
