function u = utap_pralines(pcoefs, values, occurences)

na = size(occurences, 1);
ncriteria = size(values, 2);

ui = [];
for i = 1:ncriteria
	ui(:,i) = occurences(:,i) *  polyval(pcoefs(:), values(i));
end

u = sum(ui, 2);
