function savedata(colnames, matrix, filename)

n = length(colnames);
nrow = size(matrix, 1);

fd = fopen(filename, 'w+');
for j = 1:n
	name = colnames{j};
	fprintf(fd, '%s,', name);
end

fprintf(fd, '\n');

for i = 1:nrow
	for j = 1:n
		fprintf(fd, '%g,', matrix(i, j));
	end

	fprintf(fd, '\n');
end

fclose(fd);
