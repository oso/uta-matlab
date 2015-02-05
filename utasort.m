function s = utasort(xpts, uis, ucats, pt)

u = uta(xpts, uis, pt);

s = ones(size(pt, 1), 1);

for i = 1:ucats
	ucat = ucats(i);
	j = find(u > ucat);
	s(j) = s(j) + 1;
end
