function test_utadisp_learn_from_csv_nseeds(csvfile, outfile, ...
					    na_learning_pc, nseeds, ...
					    degrees)

% cvx precision
% cvx_precision best

% read data from csv file
[ncategories, pt_all, assignments_all] ...
	= data_get_pt_aa(csvfile);

% number of alternatives and criteria
na = size(pt_all, 1)
ncriteria = size(pt_all, 2)

% domains of the criteria
%xdomains = repmat([0 1], ncriteria, 1);
xdomains = [min(pt_all)' max(pt_all)'];

results_learning = cell(1, length(degrees));
results_test = cell(1, length(degrees));
for seed = 1:nseeds
	rand('seed', seed);

	fprintf('seed: %d\n', seed);

	na_learning = ceil(na * na_learning_pc / 100);
	learning_indices = randi(na, na_learning, 1);
	test_indices = setdiff([1:1:na], learning_indices);
	pt = pt_all(learning_indices, :);
	pt_test = pt_all(test_indices, :);
	assignments = assignments_all(learning_indices, :);
	assignments_test = assignments_all(test_indices, :);

	for i = 1:length(degrees)
		deg = degrees(i);

		% compute polynomials
		[pcoefs, ucats2, cvx_status] = ...
			utadisp_learn(deg, xdomains, ncategories, ...
				      pt, assignments);

		% check cvx status
		k = strfind(cvx_status, 'Solved');
		if length(k) < 1
			fprintf('error: cvx_status: %s\n', cvx_status);
			continue;
		end

		% Assign learning set and compute ca
		u2 = utap(pcoefs, pt);
		assignments2 = utasort(ucats2, u2);
		ca_learning = compute_ca(assignments, assignments2);

		% Assign test set and compute ca
		u2 = utap(pcoefs, pt_test);
		assignments2 = utasort(ucats2, u2);
		ca_test = compute_ca(assignments_test, assignments2);

		% Store ca
		results_learning(seed, i) = {ca_learning};
		results_test(seed, i) = {ca_test};
	end
end

fd = fopen(outfile, 'a+');
for i = 1:length(degrees)
	degree = degrees(i)
	ca_learning = cell2mat(results_learning(:, i));
	ca_test = cell2mat(results_test(:, i));

	fprintf(fd, '*** degree: %d\n', degree);
	fprintf(fd, 'pclearning %d\n', na_learning_pc);
	fprintf(fd, '\nca learning set\n');
	dlmwrite(outfile, ca_learning, '-append');
	fprintf(fd, '\nca test set\n');
	dlmwrite(outfile, ca_test, '-append')

	fprintf(fd, '\nca learning average %g +- %g\n', ...
		mean(ca_learning), std(ca_learning));
	fprintf(fd, '\nca test average %g +- %g\n', ...
		mean(ca_test), std(ca_test));
	fprintf(fd, '\n\n');
end
fclose(fd);
