function ca = compute_ca(assignments, assignments2)

na = length(assignments);
assign_diff = assignments - assignments2;
errors = size(find(assign_diff > 0), 1);
ca = (na - errors) / na;
