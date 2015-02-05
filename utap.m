function u = utap(pcoefs, pt)

na = size(pt, 1)
ncriteria = size(pt, 2);

ui = [];
for i = 1:ncriteria
	ui(:,i) = polyval(pcoefs(i,:), pt(:,i));
end

u = sum(ui, 2);
