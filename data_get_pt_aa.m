function [ncategories, pt, aa] = data_get_pt_aa(csvfile)

ncategories = csvread(csvfile, 0, 1, [0 1 0 1]);
ncriteria = csvread(csvfile, 1, 1, [1 1 1 1]);
ptaa = csvread(csvfile, 4, 1);
pt = ptaa(:, 1:ncriteria);
aa = ptaa(:, ncriteria + 1);
