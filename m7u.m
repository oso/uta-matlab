function [u, ui] = m7u(pt)

ncriteria = size(pt, 2);

ui(:,1) = m2u1(pt(:,1)) ./ ncriteria;
ui(:,2) = m2u2(pt(:,2)) ./ ncriteria;
ui(:,3) = m2u3(pt(:,3)) ./ ncriteria;
ui(:,4) = m4u2(pt(:,4)) ./ ncriteria;
ui(:,5) = m4u3(pt(:,5)) ./ ncriteria;

u = sum(ui, 2);
