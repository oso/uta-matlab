close all; clear all; clc;

nseeds = 100

% 1 segments; 1st degree; 0 continuity

infile = 'data/cpu_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cpu_30pc_1seg_1deg_0cont.txt', ...
				   30, nseeds, 1, 1, 0)
infile = 'data/cpu_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cpu_50pc_1seg_1deg_0cont.txt', ...
				   50, nseeds, 1, 1, 0)
infile = 'data/cpu_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cpu_70pc_1seg_1deg_0cont.txt', ...
				   70, nseeds, 1, 1, 0)

infile = 'data/cev_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cev_30pc_1seg_1deg_0cont.txt', ...
				   30, nseeds, 1, 1, 0)
infile = 'data/cev_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cev_50pc_1seg_1deg_0cont.txt', ...
				   50, nseeds, 1, 1, 0)
infile = 'data/cev_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cev_70pc_1seg_1deg_0cont.txt', ...
				   70, nseeds, 1, 1, 0)

infile = 'data/jra_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'jra_30pc_1seg_1deg_0cont.txt', ...
				   30, nseeds, 1, 1, 0)
infile = 'data/jra_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'jra_50pc_1seg_1deg_0cont.txt', ...
				   50, nseeds, 1, 1, 0)
infile = 'data/jra_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'jra_70pc_1seg_1deg_0cont.txt', ...
				   70, nseeds, 1, 1, 0)

infile = 'data/swd_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'swd_30pc_1seg_1deg_0cont.txt', ...
				   30, nseeds, 1, 1, 0)
infile = 'data/swd_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'swd_50pc_1seg_1deg_0cont.txt', ...
				   50, nseeds, 1, 1, 0)
infile = 'data/swd_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'swd_70pc_1seg_1deg_0cont.txt', ...
				   70, nseeds, 1, 1, 0)

infile = 'data/lev_5_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'lev_30pc_1seg_1deg_0cont.txt', ...
				   30, nseeds, 1, 1, 0)
infile = 'data/lev_5_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'lev_50pc_1seg_1deg_0cont.txt', ...
				   50, nseeds, 1, 1, 0)
infile = 'data/lev_5_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'lev_70pc_1seg_1deg_0cont.txt', ...
				   70, nseeds, 1, 1, 0)

% 2 segments; 1st degree; 0 continuity

infile = 'data/cpu_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cpu_30pc_2seg_1deg_0cont.txt', ...
				   30, nseeds, 2, 1, 0)
infile = 'data/cpu_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cpu_50pc_2seg_1deg_0cont.txt', ...
				   50, nseeds, 2, 1, 0)
infile = 'data/cpu_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cpu_70pc_2seg_1deg_0cont.txt', ...
				   70, nseeds, 2, 1, 0)

infile = 'data/cev_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cev_30pc_2seg_1deg_0cont.txt', ...
				   30, nseeds, 2, 1, 0)
infile = 'data/cev_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cev_50pc_2seg_1deg_0cont.txt', ...
				   50, nseeds, 2, 1, 0)
infile = 'data/cev_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cev_70pc_2seg_1deg_0cont.txt', ...
				   70, nseeds, 2, 1, 0)

infile = 'data/jra_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'jra_30pc_2seg_1deg_0cont.txt', ...
				   30, nseeds, 2, 1, 0)
infile = 'data/jra_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'jra_50pc_2seg_1deg_0cont.txt', ...
				   50, nseeds, 2, 1, 0)
infile = 'data/jra_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'jra_70pc_2seg_1deg_0cont.txt', ...
				   70, nseeds, 2, 1, 0)

infile = 'data/swd_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'swd_30pc_2seg_1deg_0cont.txt', ...
				   30, nseeds, 2, 1, 0)
infile = 'data/swd_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'swd_50pc_2seg_1deg_0cont.txt', ...
				   50, nseeds, 2, 1, 0)
infile = 'data/swd_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'swd_70pc_2seg_1deg_0cont.txt', ...
				   70, nseeds, 2, 1, 0)

infile = 'data/lev_5_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'lev_30pc_2seg_1deg_0cont.txt', ...
				   30, nseeds, 2, 1, 0)
infile = 'data/lev_5_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'lev_50pc_2seg_1deg_0cont.txt', ...
				   50, nseeds, 2, 1, 0)
infile = 'data/lev_5_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'lev_70pc_2seg_1deg_0cont.txt', ...
				   70, nseeds, 2, 1, 0)

% 3 segments; 1st degree; 0 continuity

infile = 'data/cpu_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cpu_30pc_3seg_1deg_0cont.txt', ...
				   30, nseeds, 3, 1, 0)
infile = 'data/cpu_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cpu_50pc_3seg_1deg_0cont.txt', ...
				   50, nseeds, 3, 1, 0)
infile = 'data/cpu_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cpu_70pc_3seg_1deg_0cont.txt', ...
				   70, nseeds, 3, 1, 0)

infile = 'data/cev_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cev_30pc_3seg_1deg_0cont.txt', ...
				   30, nseeds, 3, 1, 0)
infile = 'data/cev_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cev_50pc_3seg_1deg_0cont.txt', ...
				   50, nseeds, 3, 1, 0)
infile = 'data/cev_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'cev_70pc_3seg_1deg_0cont.txt', ...
				   70, nseeds, 3, 1, 0)

infile = 'data/jra_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'jra_30pc_3seg_1deg_0cont.txt', ...
				   30, nseeds, 3, 1, 0)
infile = 'data/jra_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'jra_50pc_3seg_1deg_0cont.txt', ...
				   50, nseeds, 3, 1, 0)
infile = 'data/jra_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'jra_70pc_3seg_1deg_0cont.txt', ...
				   70, nseeds, 3, 1, 0)

infile = 'data/swd_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'swd_30pc_3seg_1deg_0cont.txt', ...
				   30, nseeds, 3, 1, 0)
infile = 'data/swd_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'swd_50pc_3seg_1deg_0cont.txt', ...
				   50, nseeds, 3, 1, 0)
infile = 'data/swd_4_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'swd_70pc_3seg_1deg_0cont.txt', ...
				   70, nseeds, 3, 1, 0)

infile = 'data/lev_5_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'lev_30pc_3seg_1deg_0cont.txt', ...
				   30, nseeds, 3, 1, 0)
infile = 'data/lev_5_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'lev_50pc_3seg_1deg_0cont.txt', ...
				   50, nseeds, 3, 1, 0)
infile = 'data/lev_5_categories.csv'
test_utadiss_learn_from_csv_nseeds(infile, 'lev_70pc_3seg_1deg_0cont.txt', ...
				   70, nseeds, 3, 1, 0)
