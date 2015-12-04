close all; clear all; clc;

degrees = [3 5 7 9]
pclearning = [30 50 70]
nseeds = 100

infile = 'data/cev_4_categories.csv'
outfile = 'cev_results2.txt'
for pc = pclearning
	test_utadisp_learn_from_csv_nseeds(infile, outfile, ...
					   pc, nseeds, degrees)
end

infile = 'data/lev_5_categories.csv'
outfile = 'lev_results2.txt'
for pc = pclearning
	test_utadisp_learn_from_csv_nseeds(infile, outfile, ...
					   pc, nseeds, degrees)
end

infile = 'data/cpu_4_categories.csv'
outfile = 'cpu_results2.txt'
for pc = pclearning
	test_utadisp_learn_from_csv_nseeds(infile, outfile, ...
					   pc, nseeds, degrees)
end

infile = 'data/jra_4_categories.csv'
outfile = 'jra_results2.txt'
for pc = pclearning
	test_utadisp_learn_from_csv_nseeds(infile, outfile, ...
					   pc, nseeds, degrees)
end

infile = 'data/swd_4_categories.csv'
outfile = 'swd_results2.txt'
for pc = pclearning
	test_utadisp_learn_from_csv_nseeds(infile, outfile, ...
					   pc, nseeds, degrees)
end
