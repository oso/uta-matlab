u1 = uta([0 5 10], [0 2 5], [2])
u2 = uta([0 5 10], [0 2 5], [5])
u3 = uta([0 5 10], [0 2 5], [8.5])
u4 = uta([0 5 10], [0 2 5], [10])
u5 = uta([0 5 10], [0 2 5], [0])
u6 = uta([0 5 10], [0 2 5], [9])
u7 = uta([0 5 10; 0 2 4], [0 1 5; 0 2 3], [2.5 1; 7.5 3; 5 2])

if u1 ~= 0.8
	fprintf('ERROR: u1 = %f != 0.8\n', u1);
end
if u2 ~= 2
	fprintf('ERROR: u2 = %f != 2\n', u2);
end
if u3 ~= 4.1
	fprintf('ERROR: u3 = %f != 4.1\n', u3);
end
if u4 ~= 5
	fprintf('ERROR: u4 = %f != 5\n', u4);
end
if u5 ~= 0
	fprintf('ERROR: u5 = %f != 0\n', u5);
end
if u6 ~= 4.4
	fprintf('ERROR: u6 = %f != 0.8\n', u6);
end
if ~isequal(u7, [1.5; 5.5; 3])
	fprintf('ERROR: u7 = %f\n', u7)
end
