function [tau] = compute_kendall_tau(ranking, ranking2)

na = length(ranking);
pairs = combnk(1:1:na, 2);

tau = 0;
for i = 1:size(pairs, 1)
	a1 = pairs(i, 1);
	a2 = pairs(i, 2);

	diffrank = ranking(a1) - ranking(a2);
	diffrank2 = ranking2(a1) - ranking2(a2);

	if sign(diffrank) ~= sign(diffrank2)
		tau = tau + 1;
	end
end

tau = 1 - 4 * tau / (na * (na - 1));
