% TODO(brwr): 50 is hard-coded
clear all

load subject1
load subject2
load subject3

% part_length1 = 50000;
% part_length2 = 50000;
% part_length3 = 50000;

% TODO(brwr): Track down refs and change to 1, 2, 3
% part_length = 50000;

% TODO(brwr): Expand this to all data and channels
% sub_1_train_part = Train_ECoG_1(1:part_length1, 16:31);
% sub_2_train_part = Train_ECoG_2(1:part_length1, 16:31);
% sub_3_train_part = Train_ECoG_3(1:part_length1, 16:31);
% 
% sub_1_glove_part = Train_Glove_1(1:part_length2, 1:5);
% sub_2_glove_part = Train_Glove_2(1:part_length2, 1:5);
% sub_3_glove_part = Train_Glove_3(1:part_length2, 1:5);
% 
% sub_1_test_part = Test_ECoG_1(1:part_length3, 16:31);
% sub_2_test_part = Test_ECoG_2(1:part_length3, 16:31);
% sub_3_test_part = Test_ECoG_3(1:part_length3, 16:31);

%sub_1_train_MA = MovingAverage(Train_ECoG_1); disp('1 Train MA')
%save('subject1a.mat', 'sub_1_train_MA'); % clear s*
%sub_1_train_FD = MovingFreqDomain(Train_ECoG_1); disp('1 Train FD')
%save('subject1b.mat', 'sub_1_train_FD'); %clear s*
%sub_1_glove_MA = MovingAverage(Train_Glove_1); disp('1 Glove MA')
%save('subject1c.mat', 'sub_1_glove_MA'); %clear s*
%sub_1_glove_FD = MovingFreqDomain(Train_Glove_1); disp('1 Glove FD')
%save('subject1d.mat', 'sub_1_glove_FD'); %clear s*
%sub_1_test_MA = MovingAverage(Test_ECoG_1); disp('1 Test MA')
%save('subject1e.mat', 'sub_1_test_MA'); %clear s*
%sub_1_test_FD = MovingFreqDomain(Test_ECoG_1); disp('1 Test FD')
%save('subject1f.mat', 'sub_1_test_FD'); %clear s*

%sub_2_train_MA = MovingAverage(Train_ECoG_2); disp('2 Train MA')
%save('subject2a.mat', 'sub_2_train_MA'); clear s*
%sub_2_train_FD = MovingFreqDomain(Train_ECoG_2); disp('2 Train FD')
%save('subject2b.mat', 'sub_2_train_FD'); clear s*
%sub_2_glove_MA = MovingAverage(Train_Glove_2); disp('2 Glove MA')
%save('subject2c.mat', 'sub_2_glove_MA'); clear s*
%sub_2_glove_FD = MovingFreqDomain(Train_Glove_2); disp('2 Glove FD')
%save('subject2d.mat', 'sub_2_glove_FD'); clear s*
%sub_2_test_MA = MovingAverage(Test_ECoG_2); disp('2 Test MA')
%save('subject2e.mat', 'sub_2_test_MA'); clear s*
%sub_2_test_FD = MovingFreqDomain(Test_ECoG_2); disp('2 Test FD')
%save('subject2f.mat', 'sub_2_test_FD'); clear s*

%sub_3_train_MA = MovingAverage(Train_ECoG_3); disp('3 Train MA')
%save('subject3a.mat', 'sub_3_train_MA'); clear s*
%sub_3_train_FD = MovingFreqDomain(Train_ECoG_3); disp('3 Train FD')
%save('subject3b.mat', 'sub_3_train_FD'); clear s*
%sub_3_glove_MA = MovingAverage(Train_Glove_3); disp('3 Glove MA')
%save('subject3c.mat', 'sub_3_glove_MA'); clear s*
%sub_3_glove_FD = MovingFreqDomain(Train_Glove_3); disp('3 Glove FD')
%save('subject3d.mat', 'sub_3_glove_FD'); clear s*
%sub_3_test_MA = MovingAverage(Test_ECoG_3); disp('3 Test MA')
%save('subject3e.mat', 'sub_3_test_MA'); clear s*
%sub_3_test_FD = MovingFreqDomain(Test_ECoG_3); disp('3 Test FD')
%save('subject3f.mat', 'sub_3_test_FD'); clear s*


load subject1a 
load subject1b
load subject1e
load subject1f
load subject2a
load subject2b
load subject2e
load subject2f
load subject3a
load subject3b
load subject3e
load subject3f

sub_1_test_final = [sub_1_test_MA , sub_1_test_FD];
sub_1_train_final = [sub_1_train_MA , sub_1_train_FD];

sub_2_test_final = [sub_2_test_MA , sub_2_test_FD];
sub_2_train_final = [sub_2_train_MA , sub_2_train_FD];

sub_3_test_final = [sub_3_test_MA , sub_3_test_FD];
sub_3_train_final = [sub_3_train_MA , sub_3_train_FD];

for j = 1:5
     sub1_glove_decimated(:, j) = decimate(Train_Glove_1(:, j), 50);
     sub2_glove_decimated(:, j) = decimate(Train_Glove_2(:, j), 50);
     sub3_glove_decimated(:, j) = decimate(Train_Glove_3(:, j), 50);
end

N = 3; % Number of delays

R1_full = GenerateRMatrix(sub_1_train_final, N);
R2_full = GenerateRMatrix(sub_2_train_final, N);
R3_full = GenerateRMatrix(sub_3_train_final, N);

R1 = R1_full(1 + N : end - N, :);
R2 = R2_full(1 + N : end - N, :);
R3 = R3_full(1 + N : end - N, :);

Y1 = sub1_glove_decimated(1 + N : end - N, :);
Y2 = sub2_glove_decimated(1 + N : end - N, :);
Y3 = sub3_glove_decimated(1 + N : end - N, :);

beta1 = (R1' * R1) \ R1' * Y1;
beta2 = (R2' * R2) \ R2' * Y2;
beta3 = (R3' * R3) \ R3' * Y3;

R1_X = GenerateRMatrix(sub_1_test_final, N);
R2_X = GenerateRMatrix(sub_2_test_final, N);
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

YY1 = spline(0 : 50 : L1 - 1, Y1_Final', (0 : L1 - 1))';
YY2 = spline(0 : 50 : L2 - 1, Y2_Final', (0 : L2 - 1))';
YY3 = spline(0 : 50 : L3 - 1, Y3_Final', (0 : L3 - 1))';


