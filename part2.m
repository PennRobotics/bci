clear all

load subject1
load subject2
load subject3

part_length1 = 50000;
part_length2 = 50000;
part_length3 = 50000;

% TODO(brwr): Track down refs and change to 1, 2, 3
part_length = 50000;

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

sub_1_train = Train_ECoG_1(:, :);
sub_2_train = Train_ECoG_2(:, :);
sub_3_train = Train_ECoG_3(:, :);

sub_1_glove = Train_Glove_1(:, :);
sub_2_glove = Train_Glove_2(:, :);
sub_3_glove = Train_Glove_3(:, :);

sub_1_test = Test_ECoG_1(:, :);
sub_2_test = Test_ECoG_2(:, :);
sub_3_test = Test_ECoG_3(:, :);

clear T*

sub_1_train_MA = MovingAverage(sub_1_train);
sub_2_train_MA = MovingAverage(sub_2_train);
sub_3_train_MA = MovingAverage(sub_3_train);

sub_1_glove_MA = MovingAverage(sub_1_glove);
sub_2_glove_MA = MovingAverage(sub_2_glove);
sub_3_glove_MA = MovingAverage(sub_3_glove);

sub_1_test_MA = MovingAverage(sub_1_test);
sub_2_test_MA = MovingAverage(sub_2_test);
sub_3_test_MA = MovingAverage(sub_3_test);

sub_1_train_FD = MovingFreqDomain(sub_1_train);
sub_2_train_FD = MovingFreqDomain(sub_2_train);
sub_3_train_FD = MovingFreqDomain(sub_3_train);

sub_1_glove_FD = MovingFreqDomain(sub_1_glove);
sub_2_glove_FD = MovingFreqDomain(sub_2_glove);
sub_3_glove_FD = MovingFreqDomain(sub_3_glove);

sub_1_test_FD = MovingFreqDomain(sub_1_test);
sub_2_test_FD = MovingFreqDomain(sub_2_test);
sub_3_test_FD = MovingFreqDomain(sub_3_test);

save('subject1features.mat', 'sub_1_train_MA', 'sub_1_glove_MA', 'sub_1_test_MA', ...
                             'sub_1_train_FD', 'sub_1_glove_FD', 'sub_1_test_FD');

save('subject2features.mat', 'sub_2_train_MA', 'sub_2_glove_MA', 'sub_2_test_MA', ...
                             'sub_2_train_FD', 'sub_2_glove_FD', 'sub_2_test_FD');

save('subject3features.mat', 'sub_3_train_MA', 'sub_3_glove_MA', 'sub_3_test_MA', ...
                             'sub_3_train_FD', 'sub_3_glove_FD', 'sub_3_test_FD');

