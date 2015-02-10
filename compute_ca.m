function ca = compute_ca(assignments, assignments2)

na = length(assignments);
assign_diff = abs(assignments - assignments2);
errors = size(find(assign_diff > 0), 1);
length(errors)
ca = (na - errors) / na;
