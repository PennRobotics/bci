function R = GenerateRMatrix(input, N);
M = size(input, 1) - N + 1;
v = size(input, 2);

% R matrix
R = ones(M, (1+(N*v)));    %easier to make first column a column of ones
r = zeros(M, (N*v));
ij = 0;

for i = 1 : M
    r(i, :) = reshape(input((ij + 1) : (N + ij), :), 1, []);
    ij = ij + 1;
end
R(:, 2 : end) = r;    %Response matrixend
fprintf('(GenerateRMatrix) Mean in Gen Function = %f\n', mean(mean(R)));
end
