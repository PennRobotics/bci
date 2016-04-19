function [ R ] = Get_R_Matrix( matrix_input)
%UNTITLED4 Summary of this function goes here
%   your matrix_input's column count (e.g. 310000x62 means 62 columns) is
%   the number of neurons in the matrix.

%note that your matrix_input's column count (e.g. 310000x62 means 62
%columns) is the number of neurons;
nu = length(matrix_input(1, :));
sprintf('nu is %d', nu)
N = 3; %given in HW
M = length(matrix_input(1, :)); %given in HW
R = [];
for row = 1:1:M;
    row_to_add = [1];
    for j = 1:1:nu
        for i = 1:1:N
            row_to_add = [row_to_add, matrix_input(i+row-1, j)];
        end
    end
    %     size(R); %for debugging only
    R = [R; row_to_add];
end

end

