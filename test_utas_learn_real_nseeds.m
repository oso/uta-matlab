function results = test_utas_learn_real_nseeds(nseeds, model, ncriteria, ...
					       na, nagen, ...
					       nsegments, degree, ...
					       continuity, filename)

results = [0 0 0 0 0 0];

for i = 1:nseeds
	[spearmand, kendallt, spearmand_gen, kendallt_gen, cvx_optval, ...
	 cvx_cputime] = ...
		test_utas_learn_real(i, model, ncriteria, na, nagen, ...
				     nsegments, degree, continuity, 0);

	results(i, :) = [cvx_optval, cvx_cputime, spearmand, kendallt, spearmand_gen, kendallt_gen];
end

results

delete(filename)
fd = fopen(filename, 'a+');
fprintf(fd, 'model:      %s\n', func2str(model));
fprintf(fd, 'ncriteria:  %d\n', ncriteria);
fprintf(fd, 'na:         %d\n', na);
fprintf(fd, 'nagen:      %d\n', nagen);
fprintf(fd, 'nsegments:  %d\n', nsegments);
fprintf(fd, 'degree:     %d\n', degree);
fprintf(fd, 'continuity: %d\n\n', continuity);
fprintf(fd, 'nseeds:     %d\n', nseeds);

fprintf(fd, 'spearman distance and kendall tau of learning and test sets\n');
dlmwrite(filename, results, '-append');

results_mean = mean(results);
results_std = std(results);
fprintf(fd, '\n');
fprintf(fd, 'objective value (avg):   %g +- %g\n', results_mean(1), results_std(1));
fprintf(fd, 'cputime (avg):           %g +- %g\n', results_mean(2), results_std(2));
fprintf(fd, 'spearman learning (avg): %g +- %g\n', results_mean(3), results_std(3));
fprintf(fd, 'kendall learning (avg):  %g +- %g\n', results_mean(4), results_std(4));
fprintf(fd, 'spearman test (avg):     %g +- %g\n', results_mean(5), results_std(5));
fprintf(fd, 'kendall test (avg):      %g +- %g\n', results_mean(6), results_std(6));

fclose(fd);
