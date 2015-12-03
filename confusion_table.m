function [table] = confusion_table(assignments, assignments2)

catmax = max([assignments' assignments2']);
table = zeros(catmax, catmax);

for i = 1:length(assignments)
	a1 = assignments(i);
	a2 = assignments2(i);
	table(a1, a2) = table(a1, a2) + 1;
end
