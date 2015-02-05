function s = utasort(ucats, u)

s = ones(size(u, 1), 1);

for i = 1:length(ucats)
	ucat = ucats(i);
	j = find(u > ucat);
	s(j) = s(j) + 1;
end
