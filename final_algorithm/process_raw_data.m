%% PROCESS RAW DATA
%  
%  This function ...
%  ... Constructs features from transient data
%  ... Filters signals deemed improper
%  

disp('Processing Raw Data')

clear all

%% VARIABLES
Ts =  40;  % Sample period [ms]
Tw = 240;  % Window duration [ms]
N  =   3;  % (Num Delays) Number of subsequent samples to concatenate

%% PROCESS CODE
disp('Loading Subject Raw Features')
load subject1
load subject2
load subject3

disp('Remove Channel 55 from Subject 1')
Train_ECoG_1(:, 55) = [];
Test_ECoG_1(:, 55) = [];

disp('Generating New Features')
sub_1_train_MA = FnMovingAverageAdj(Train_ECoG_1, Ts, Tw); disp('1 Train MA')
sub_1_train_FD = FnMovingFreqDomAdj(Train_ECoG_1, Ts, Tw); disp('1 Train FD')
sub_1_test_MA  = FnMovingAverageAdj( Test_ECoG_1, Ts, Tw); disp('1 Test MA')
sub_1_test_FD  = FnMovingFreqDomAdj( Test_ECoG_1, Ts, Tw); disp('1 Test FD')

sub_2_train_MA = FnMovingAverageAdj(Train_ECoG_2, Ts, Tw); disp('2 Train MA')
sub_2_train_FD = FnMovingFreqDomAdj(Train_ECoG_2, Ts, Tw); disp('2 Train FD')
sub_2_test_MA  = FnMovingAverageAdj( Test_ECoG_2, Ts, Tw); disp('2 Test MA')
sub_2_test_FD  = FnMovingFreqDomAdj( Test_ECoG_2, Ts, Tw); disp('2 Test FD')

sub_3_train_MA = FnMovingAverageAdj(Train_ECoG_3, Ts, Tw); disp('3 Train MA')
sub_3_train_FD = FnMovingFreqDomAdj(Train_ECoG_3, Ts, Tw); disp('3 Train FD')
sub_3_test_MA  = FnMovingAverageAdj( Test_ECoG_3, Ts, Tw); disp('3 Test MA')
sub_3_test_FD  = FnMovingFreqDomAdj( Test_ECoG_3, Ts, Tw); disp('3 Test FD')

sub_1_glove_decimated = FnMovingAverageAdj(Train_Glove_1, Ts, Tw); disp('1 Glove MA')
sub_2_glove_decimated = FnMovingAverageAdj(Train_Glove_2, Ts, Tw); disp('2 Glove MA')
sub_3_glove_decimated = FnMovingAverageAdj(Train_Glove_3, Ts, Tw); disp('3 Glove MA')

disp('Concatenate Subject Features')

sub_1_train_final = [sub_1_train_MA , sub_1_train_FD];
sub_1_test_final = [sub_1_test_MA , sub_1_test_FD];

sub_2_train_final = [sub_2_train_MA , sub_2_train_FD];
sub_2_test_final = [sub_2_test_MA , sub_2_test_FD];

sub_3_train_final = [sub_3_train_MA , sub_3_train_FD];
sub_3_test_final = [sub_3_test_MA , sub_3_test_FD];

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

%% GENERATE OUTPUT
disp('Generate Output')
Y1_hat = X1 * beta1;
Y2_hat = X2 * beta2;
Y3_hat = X3 * beta3;

disp('Pad Outputs')
Y1_Final = [repmat(Y1_hat(1, :),N,1); Y1_hat; repmat(Y1_hat(end, :),N,1)];
Y2_Final = [repmat(Y2_hat(1, :),N,1); Y2_hat; repmat(Y2_hat(end, :),N,1)];
Y3_Final = [repmat(Y3_hat(1, :),N,1); Y3_hat; repmat(Y3_hat(end, :),N,1)];

L1 = size(Test_ECoG_1, 1);
L2 = size(Test_ECoG_2, 1);
L3 = size(Test_ECoG_3, 1);

disp('Output PCHIP')
 YY1 = pchip(linspace(0, L1, size(Y1_Final, 1)), Y1_Final', linspace(0, L1, L1))';
 YY2 = pchip(linspace(0, L2, size(Y2_Final, 1)), Y2_Final', linspace(0, L2, L2))';
 YY3 = pchip(linspace(0, L3, size(Y3_Final, 1)), Y3_Final', linspace(0, L3, L3))';

predicted_dg{1} = YY1;
predicted_dg{2} = YY2;
predicted_dg{3} = YY3;

disp('Saving axon_fired.mat')
save('axon_fired.mat', 'predicted_dg');

disp('Done.')
disp(' ')
disp(' ')
