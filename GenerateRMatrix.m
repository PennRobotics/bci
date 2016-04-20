function R = GenerateRMatrix(input, N);
M = size(input, 1);
v = size(input, 2);

R = zeros(M, 1+(N*v));
for row = 1 : M-N+1
  row_to_add = [1];
  for j = 1 : v
    for i = 1 : N
      row_to_add = [row_to_add, input(i + row - 1, j)];
    end
  end
  R(row, :) = row_to_add;
end
end
