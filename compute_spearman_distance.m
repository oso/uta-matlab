function [d] = compute_spearman_distance(ranking, ranking2)

na = length(ranking);
d = 0;

for i = 1:na
	r1 = ranking(i);
	r2 = ranking2(i);

	d = d + (r1 - r2)^2;
end

d = 1 - (6 * d) / (na * (na^2 -1));
