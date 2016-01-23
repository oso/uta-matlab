function [u, ui] = m4u(pt)

ncriteria = size(pt, 2);

ui(:,1) = m4u1(pt(:,1)) ./ ncriteria;
ui(:,2) = m4u2(pt(:,2)) ./ ncriteria;
ui(:,3) = m4u3(pt(:,3)) ./ ncriteria;

u = sum(ui, 2);
