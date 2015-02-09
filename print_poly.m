function str = printpoly(p)

deg = length(p) - 1;

str = sprintf('%g', p(end));
for d = 1:deg
	coef = p(end - d);
	if coef >= 0
		str = strcat(str, ' + ');
	else
		str = sprintf(str, ' - ');
	end
	str = sprintf('%s %g*x^%d', str, abs(coef), d);
end
