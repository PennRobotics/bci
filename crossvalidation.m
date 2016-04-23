% TODO(brwr): 50 is hard-coded
clear all

disp('Loading Subject Raw Features')
load subject1
load subject2
load subject3

disp('Generating New Features')
% sub_1_train_MA = MovingAverage(Train_ECoG_1); disp('1 Train MA')
% save('subject1a.mat', 'sub_1_train_MA'); % clear s*
% sub_1_train_FD = MovingFreqDomain(Train_ECoG_1); disp('1 Train FD')
% save('subject1b.mat', 'sub_1_train_FD'); %clear s*
% % sub_1_glove_MA = MovingAverage(Train_Glove_1); disp('1 Glove MA')
% % save('subject1c.mat', 'sub_1_glove_MA'); %clear s*
% % sub_1_glove_FD = MovingFreqDomain(Train_Glove_1); disp('1 Glove FD')
% % save('subject1d.mat', 'sub_1_glove_FD'); %clear s*
% sub_1_test_MA = MovingAverage(Test_ECoG_1); disp('1 Test MA')
% save('subject1e.mat', 'sub_1_test_MA'); %clear s*
% sub_1_test_FD = MovingFreqDomain(Test_ECoG_1); disp('1 Test FD')
% save('subject1f.mat', 'sub_1_test_FD'); %clear s*

% sub_2_train_MA = MovingAverage(Train_ECoG_2); disp('2 Train MA')
% save('subject2a.mat', 'sub_2_train_MA'); clear s*
% sub_2_train_FD = MovingFreqDomain(Train_ECoG_2); disp('2 Train FD')
% save('subject2b.mat', 'sub_2_train_FD'); clear s*
% % sub_2_glove_MA = MovingAverage(Train_Glove_2); disp('2 Glove MA')
% % save('subject2c.mat', 'sub_2_glove_MA'); clear s*
% % sub_2_glove_FD = MovingFreqDomain(Train_Glove_2); disp('2 Glove FD')
% % save('subject2d.mat', 'sub_2_glove_FD'); clear s*
% sub_2_test_MA = MovingAverage(Test_ECoG_2); disp('2 Test MA')
% save('subject2e.mat', 'sub_2_test_MA'); clear s*
% sub_2_test_FD = MovingFreqDomain(Test_ECoG_2); disp('2 Test FD')
% save('subject2f.mat', 'sub_2_test_FD'); clear s*

% sub_3_train_MA = MovingAverage(Train_ECoG_3); disp('3 Train MA')
% save('subject3a.mat', 'sub_3_train_MA'); clear s*
% sub_3_train_FD = MovingFreqDomain(Train_ECoG_3); disp('3 Train FD')
% save('subject3b.mat', 'sub_3_train_FD'); clear s*
% % sub_3_glove_MA = MovingAverage(Train_Glove_3); disp('3 Glove MA')
% % save('subject3c.mat', 'sub_3_glove_MA'); clear s*
% % sub_3_glove_FD = MovingFreqDomain(Train_Glove_3); disp('3 Glove FD')
% % save('subject3d.mat', 'sub_3_glove_FD'); clear s*
% sub_3_test_MA = MovingAverage(Test_ECoG_3); disp('3 Test MA')
% save('subject3e.mat', 'sub_3_test_MA'); clear s*
% sub_3_test_FD = MovingFreqDomain(Test_ECoG_3); disp('3 Test FD')
% save('subject3f.mat', 'sub_3_test_FD'); clear s*


disp('Loading Subject Features')
load subject1a; load subject1b; load subject1e; load subject1f;
load subject2a; load subject2b; load subject2e; load subject2f;
load subject3a; load subject3b; load subject3e; load subject3f;

sub_1_train_final = [sub_1_train_MA , sub_1_train_FD];
sub_1_test_final = [sub_1_test_MA , sub_1_test_FD];

sub_2_train_final = [sub_2_train_MA , sub_2_train_FD];
sub_2_test_final = [sub_2_test_MA , sub_2_test_FD];

sub_3_train_final = [sub_3_train_MA , sub_3_train_FD];
sub_3_test_final = [sub_3_test_MA , sub_3_test_FD];

for j = 1:5
     sub1_glove_decimated(:, j) = decimate(Train_Glove_1(:, j), 50);
     sub2_glove_decimated(:, j) = decimate(Train_Glove_2(:, j), 50);
     sub3_glove_decimated(:, j) = decimate(Train_Glove_3(:, j), 50);
end

% Remove channel 55 from subject 1 dataset
% TODO(brwr): Make sure this works properly!
% sub_1_train_final(:, 55) = [];
% sub_1_test_final(:, 55) = [];

%% CROSS-VALIDATION INDEXING
percentSample = 0.2;

rng(159159);

train_index = 1 : length(Train_ECoG_1);
train_xval_index = randsample(train_index, length(Train_ECoG_1) * percentSample);

sub_1_train_xval = sub_1_train_final(train_xval_index, :);
sub_1_train_final(train_xval_index, :) = [];
sub1_glove_xval = sub1_glove_decimated(train_xval_index, :);
sub1_glove_decimated(train_xval_index, :) = [];

sub_2_train_xval = sub_2_train_final(train_xval_index, :);
sub_2_train_final(train_xval_index, :) = [];
sub2_glove_xval = sub2_glove_decimated(train_xval_index, :);
sub2_glove_decimated(train_xval_index, :) = [];

sub_3_train_xval = sub_3_train_final(train_xval_index, :);
sub_3_train_final(train_xval_index, :) = [];
sub3_glove_xval = sub3_glove_decimated(train_xval_index, :);
sub3_glove_decimated(train_xval_index, :) = [];

%% PROCESS DATA
N = 3; % Number of delays

disp('1/3  Generating Training R Matrices')
R1_full = GenerateRMatrix(sub_1_train_final, N);
disp('2/3')
R2_full = GenerateRMatrix(sub_2_train_final, N);
disp('3/3')
R3_full = GenerateRMatrix(sub_3_train_final, N);

% R1 = R1_full(1 + N : end - N, :);
% R2 = R2_full(1 + N : end - N, :);
% R3 = R3_full(1 + N : end - N, :);
R1 = R1_full;
R2 = R2_full;
R3 = R3_full;

Y1 = sub1_glove_decimated(N : end, :);
Y2 = sub2_glove_decimated(N : end, :);
Y3 = sub3_glove_decimated(N : end, :);

disp('Linear Regression')
beta1 = (R1' * R1) \ (R1' * Y1);
beta2 = (R2' * R2) \ (R2' * Y2);
beta3 = (R3' * R3) \ (R3' * Y3);

%% CROSS-VALIDATION
disp('1/3  Generating Cross-Validation R Matrices');
R1_XV = GenerateRMatrix(sub_1_train_xval, N);
disp('2/3')
R2_XV = GenerateRMatrix(sub_2_train_xval, N);
disp('3/3')
R3_XV = GenerateRMatrix(sub_3_train_xval, N);

% XV1 = R1_XV(1 + N : end - N, :); 
% XV2 = R2_XV(1 + N : end - N, :); 
% XV3 = R3_XV(1 + N : end - N, :); 
XV1 = R1_XV;
XV2 = R2_XV;
XV3 = R3_XV;

YV1_hat = XV1 * beta1;
YV2_hat = XV2 * beta2;
YV3_hat = XV3 * beta3;

YV1_Final = [repmat(YV1_hat(1, :),N,1); YV1_hat; repmat(YV1_hat(end, :),N,1)];
YV2_Final = [repmat(YV2_hat(1, :),N,1); YV2_hat; repmat(YV2_hat(end, :),N,1)];
YV3_Final = [repmat(YV3_hat(1, :),N,1); YV3_hat; repmat(YV3_hat(end, :),N,1)];

L1 = size(Test_ECoG_1, 1);
L2 = size(Test_ECoG_2, 1);
L3 = size(Test_ECoG_3, 1);

disp('Cross-Validation PCHIP Stage 1/2')
YYV1a = pchip(0 : 50 : L1 - 1, YV1_Final', (0 : 10 : L1 - 1))';
YYV2a = pchip(0 : 50 : L2 - 1, YV2_Final', (0 : 10 : L2 - 1))';
YYV3a = pchip(0 : 50 : L3 - 1, YV3_Final', (0 : 10 : L3 - 1))';

disp('Cross-Validation PCHIP Stage 2/2')
YYxval1 = pchip(0 : 10 : L1 - 1, YYV1a', (0 : L1 - 1))';
YYxval2 = pchip(0 : 10 : L2 - 1, YYV2a', (0 : L2 - 1))';
YYxval3 = pchip(0 : 10 : L3 - 1, YYV3a', (0 : L3 - 1))';

Y1_xval = sub1_glove_xval;
Y2_xval = sub1_glove_xval;
Y3_xval = sub1_glove_xval;

c1 = corr(YYxval1, Y1_xval);
c2 = corr(YYxval2, Y2_xval);
c3 = corr(YYxval3, Y3_xval);

%% TEST
disp('1/3  Generating Testing R Matrices')
R1_X = GenerateRMatrix(sub_1_test_final, N);
disp('2/3')
R2_X = GenerateRMatrix(sub_2_test_final, N);
disp('3/3')
R3_X = GenerateRMatrix(sub_3_test_final, N);

X1 = R1_X(1 + N : end - N, :); 
X2 = R2_X(1 + N : end - N, :); 
X3 = R3_X(1 + N : end - N, :); 

Y1_hat = X1 * beta1;
Y2_hat = X2 * beta2;
Y3_hat = X3 * beta3;

Y1_Final = [repmat(Y1_hat(1, :),N,1); Y1_hat; repmat(Y1_hat(end, :),N,1)];
Y2_Final = [repmat(Y2_hat(1, :),N,1); Y2_hat; repmat(Y2_hat(end, :),N,1)];
Y3_Final = [repmat(Y3_hat(1, :),N,1); Y3_hat; repmat(Y3_hat(end, :),N,1)];

L1 = size(Test_ECoG_1, 1);
L2 = size(Test_ECoG_2, 1);
L3 = size(Test_ECoG_3, 1);

% disp('Output Spline')
% YY1 = spline(0 : 50 : L1 - 1, Y1_Final', (0 : L1 - 1))';
% YY2 = spline(0 : 50 : L2 - 1, Y2_Final', (0 : L2 - 1))';
% YY3 = spline(0 : 50 : L3 - 1, Y3_Final', (0 : L3 - 1))';

% disp('Output PCHIP')
% YY1 = pchip(0 : 50 : L1 - 1, Y1_Final', (0 : L1 - 1))';
% YY2 = pchip(0 : 50 : L2 - 1, Y2_Final', (0 : L2 - 1))';
% YY3 = pchip(0 : 50 : L3 - 1, Y3_Final', (0 : L3 - 1))';

disp('Output PCHIP Stage 1/2')
YY1a = pchip(0 : 50 : L1 - 1, Y1_Final', (0 : 10 : L1 - 1))';
YY2a = pchip(0 : 50 : L2 - 1, Y2_Final', (0 : 10 : L2 - 1))';
YY3a = pchip(0 : 50 : L3 - 1, Y3_Final', (0 : 10 : L3 - 1))';

disp('Output PCHIP Stage 2/2')
YY1 = pchip(0 : 10 : L1 - 1, YY1a', (0 : L1 - 1))';
YY2 = pchip(0 : 10 : L2 - 1, YY2a', (0 : L2 - 1))';
YY3 = pchip(0 : 10 : L3 - 1, YY3a', (0 : L3 - 1))';

predicted_dg{1} = YY1;
predicted_dg{2} = YY2;
predicted_dg{3} = YY3;

disp('Saving axon_fired.mat')
save('axon_fired.mat', 'predicted_dg');

disp('Done.')
disp(' ')
disp(' ')

