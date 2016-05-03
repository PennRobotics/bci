%% CALCULATE R MATRIX
disp('1/3  Generating Training R Matrices')
R1_full = FnGenerateRMatrix(sub_1_train_final, N);
disp('2/3')
R2_full = FnGenerateRMatrix(sub_2_train_final, N);
disp('3/3')
R3_full = FnGenerateRMatrix(sub_3_train_final, N);

R1 = R1_full;
R2 = R2_full;
R3 = R3_full;

Y1 = sub_1_glove_decimated(N : end , :);
Y2 = sub_2_glove_decimated(N : end, :);
Y3 = sub_3_glove_decimated(N : end, :);

disp('Linear Regression')
beta1 = (R1' * R1) \ (R1' * Y1);
beta2 = (R2' * R2) \ (R2' * Y2);
beta3 = (R3' * R3) \ (R3' * Y3);

disp('1/3  Generating Testing R Matrices')
R1_X = GenerateRMatrix(sub_1_test_final, N);
disp('2/3')
R2_X = GenerateRMatrix(sub_2_test_final, N);
disp('3/3')
R3_X = GenerateRMatrix(sub_3_test_final, N);

X1 = R1_X; 
X2 = R2_X; 
X3 = R3_X; 