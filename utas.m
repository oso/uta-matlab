function u = utas(xpts, pcoefs, pt)

xpts
na = size(pt, 1);
ncriteria = size(pt, 2);
nsegments = size(xpts, 2) - 1;

for i = 1:na
	ap = pt(i, :);
	u(i) = 0;

	for j = 1:ncriteria
		for k = 2:nsegments + 1
			xpt = xpts(j, k);
			if ap(j) <= xpt
				break;
			end
		end

		xpt2 = xpts(j, k - 1);

		u(i) = u(i) + polyval(pcoefs(j, :, k - 1), ap(j));
	end
end
