function [pcoefs, cvx_status] = utap_learn(deg, xdomains, pt, ...
					   pairwisecmp)

epsilon = 0.00001;
na = size(pt, 1);
ncriteria = size(pt, 2);

n = ceil(deg / 2 + 1);

cvx_begin
	variable a(deg + 1, ncriteria);
	variable Q(n, n, ncriteria) symmetric;
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
			u2 = 0;
			for j = 1:ncriteria
				u1 = u1 + ap1(j).^(0:deg)*a(:, j);
				u2 = u2 + ap2(j).^(0:deg)*a(:, j);
			end

			if pairwisecmp(i, 3) > 0
				u1 - u2 + aplus(i1) - amin(i1) ...
					- aplus(i2) + amin(i2) >= epsilon
			elseif pairwisecmp(i, 3) < 0
				u2 - u1 + aplus(i2) - amin(i2) ...
					- aplus(i1) + amin(i1) >= epsilon
			elseif pairwisecmp(i, 3) == 0
				u2 - u1 + aplus(i2) - amin(i2) ...
					- aplus(i1) + amin(i1) == 0
			end
		end

		for j = 1:ncriteria
			Q(:, :, j) == semidefinite(n);
		end

		for j = 1:ncriteria
			xdomains(j, 1).^(0:deg)*a(:,j) == 0;
		end

		umax = 0;
		for j = 1:ncriteria
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
