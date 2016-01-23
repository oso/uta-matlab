function [u, ui] = m1u(pt)

ncriteria = size(pt, 2);

ui(:,1) = m1u1(pt(:,1)) ./ ncriteria;
ui(:,2) = m1u2(pt(:,2)) ./ ncriteria;
ui(:,3) = m1u3(pt(:,3)) ./ ncriteria;

u = sum(ui, 2);
