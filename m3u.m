function [u, ui] = m3u(pt)

ncriteria = size(pt, 2);

ui(:,1) = m3u1(pt(:,1)) ./ ncriteria;
ui(:,2) = m3u2(pt(:,2)) ./ ncriteria;
ui(:,3) = m3u3(pt(:,3)) ./ ncriteria;

u = sum(ui, 2);
