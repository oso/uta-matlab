u1 = uta([0 5 10; 0 2 4], [0 1 5; 0 2 3], [2.5 1; 7.5 3; 5 2])
s1 = utasort([2 3], u1)

if ~isequal(s1, [1; 3; 2])
	fprintf('ERROR: s1 = %d\n', s1)
end
