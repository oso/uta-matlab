function [pcoefs, cvx_status] = utap_pralines_learn(deg, xdomain, values, occurences, pairwisecmp)

xdomain
epsilon = 0.00001;
ncmp = size(pairwisecmp, 1);

n = ceil(deg / 2 + 1);

cvx_begin
	variable a(deg + 1, 1);
	variable Q(n, n) symmetric;
	variable aplus(ncmp) nonnegative;
	variable amin(ncmp) nonnegative;

	minimize (sum(aplus) + sum(amin));
	subject to
		for i = 1:ncmp
			i1 = pairwisecmp(i, 1);
			i2 = pairwisecmp(i, 2);

			n1 = occurences(i1, :);
			n2 = occurences(i2, :);

			u1 = 0;
			u2 = 0;
			for j = 1:length(values)
				u1 = u1 + n1(j) * values(j).^(0:deg) * a;
				u2 = u2 + n2(j) * values(j).^(0:deg) * a;
			end

			if pairwisecmp(i, 3) > 0
				u1 - u2 + aplus(i) - amin(i) >= epsilon
			elseif pairwisecmp(i, 3) < 0
				u2 - u1 + aplus(i) - amin(i) >= epsilon
			elseif pairwisecmp(i, 3) == 0
				u2 - u1 + aplus(i) - amin(i) == 0
			end
		end

		Q(:, :) == semidefinite(n);

		xdomain(1).^(0:deg)*a == 0;

		xdomain(2).^(0:deg)*a == 1;

		k = 1 - n;
		for i = 2:2*n
			ai = sum(diag(rot90(Q(:, :)), k));
			if i > length(a)
				ai == 0;
			else
				ai == (i - 1) * a(i);
			end

			k = k + 1;
		end
cvx_end

pcoefs = fliplr(a);
