function [ R ] = Get_R_Matrix( matrix_input, N)
%UNTITLED4 Summary of this function goes here
%   your matrix_input's column count (e.g. 310000x62 means 62 columns) is
%   the number of neurons in the matrix. N is the number of time bins to
%   average over.

%note that your matrix_input's column count (e.g. 310000x62 means 62
%columns) is the number of neurons;
nu = length(matrix_input(1, :));
sprintf('nu is %d', nu)
M = length(matrix_input(1, :)); %given in HW
sprintf('M = %d', M)
sprintf('N = %d', N)
% R = [];
R = zeros(length(matrix_input(:, 1))-N+1, 1+N*M);
for row = 1:1:M;
    row_to_add = zeros(1, (nu)*(N));
    row_to_add(1) = 1;
    for j = 1:1:nu
        for i = 1:1:N
            row_to_add(1, N * (j - 1) + (i) + 1) = matrix_input(i + row - 1, j);
        end
    end
    %     size(R); %for debugging only
%     R = [R; row_to_add];
    sprintf('row_to_add has length = %d', length(row_to_add))
    sprintf('length of R(1, 1:end) = %d', length(R(row, 1:end)))
    R(row, 1:end) = row_to_add; 
end

end

