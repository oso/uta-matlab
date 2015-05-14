function [pairwisecmp] = compute_pairwise_relations(u)

[usorted, index] = sortrows(u, 1);
na = length(u);

pairwisecmp = [zeros(1, 3)];

for i = 1:(na - 1)
	if usorted(i + 1) > usorted(i)
		pcmp = [index(i + 1), index(i), 1];
	elseif usorted(i + 1) == usorted(i)
		pcmp = [index(i + 1), index(i), 0];
	elseif usorted(i + 1) < usorted(i)
		pcmp = [index(i + 1), index(i), -1];
	end

	pairwisecmp(i, :) = pcmp;
end
