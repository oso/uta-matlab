function [u, ui] = m5u(pt)

ncriteria = size(pt, 2);

ui(:,1) = m2u1(pt(:,1)) ./ ncriteria;
ui(:,2) = m3u3(pt(:,2)) ./ ncriteria;
ui(:,3) = m4u2(pt(:,3)) ./ ncriteria;
ui(:,4) = m1u3(pt(:,4)) ./ ncriteria;
ui(:,5) = m2u2(pt(:,5)) ./ ncriteria;

u = sum(ui, 2);
