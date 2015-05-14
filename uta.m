function u = uta(xpts, uis, pt)

ncriteria = size(pt, 2);

u = zeros(size(pt, 1), 1);
for i = 1:ncriteria
	u = u + interp1(xpts(i, :), uis(i,:), pt(:,i));
end
