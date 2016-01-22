function [u, ui] = m2u(pt)

ncriteria = size(pt, 2);

ui(:,1) = m2u1(pt(:,1)) ./ ncriteria;
ui(:,2) = m2u2(pt(:,2)) ./ ncriteria;
ui(:,3) = m2u3(pt(:,3)) ./ ncriteria;

u = sum(ui, 2);
