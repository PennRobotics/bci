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

sub_1_train_MA = MovingAverage(Train_ECoG_1); disp('1 Train MA')
save('subject1a.mat', 'sub_1_train_MA'); clear s*
sub_1_train_FD = MovingFreqDomain(Train_ECoG_1); disp('1 Train FD')
save('subject1b.mat', 'sub_1_glove_MA'); clear s*
sub_1_glove_MA = MovingAverage(Train_Glove_1); disp('1 Glove MA')
save('subject1c.mat', 'sub_1_test_MA'); clear s*
sub_1_glove_FD = MovingFreqDomain(Train_Glove_1); disp('1 Glove FD')
save('subject1d.mat', 'sub_1_train_FD'); clear s*
sub_1_test_MA = MovingAverage(Test_ECoG_1); disp('1 Test MA')
save('subject1e.mat', 'sub_1_glove_FD'); clear s*
sub_1_test_FD = MovingFreqDomain(Test_ECoG_1); disp('1 Test FD')
save('subject1f.mat', 'sub_1_test_FD'); clear s*

sub_2_train_MA = MovingAverage(Train_ECoG_2); disp('2 Train MA')
save('subject2a.mat', 'sub_2_train_MA'); clear s*
sub_2_train_FD = MovingFreqDomain(Train_ECoG_2); disp('2 Train FD')
save('subject2b.mat', 'sub_2_glove_MA'); clear s*
sub_2_glove_MA = MovingAverage(Train_Glove_2); disp('2 Glove MA')
save('subject2c.mat', 'sub_2_test_MA'); clear s*
sub_2_glove_FD = MovingFreqDomain(Train_Glove_2); disp('2 Glove FD')
save('subject2d.mat', 'sub_2_train_FD'); clear s*
sub_2_test_MA = MovingAverage(Test_ECoG_2); disp('2 Test MA')
save('subject2e.mat', 'sub_2_glove_FD'); clear s*
sub_2_test_FD = MovingFreqDomain(Test_ECoG_2); disp('2 Test FD')
save('subject2f.mat', 'sub_2_test_FD'); clear s*

sub_3_train_MA = MovingAverage(Train_ECoG_3); disp('3 Train MA')
save('subject3a.mat', 'sub_3_train_MA'); clear s*
sub_3_train_FD = MovingFreqDomain(Train_ECoG_3); disp('3 Train FD')
save('subject3b.mat', 'sub_3_glove_MA'); clear s*
sub_3_glove_MA = MovingAverage(Train_Glove_3); disp('3 Glove MA')
save('subject3c.mat', 'sub_3_test_MA'); clear s*
sub_3_glove_FD = MovingFreqDomain(Train_Glove_3); disp('3 Glove FD')
save('subject3d.mat', 'sub_3_train_FD'); clear s*
sub_3_test_MA = MovingAverage(Test_ECoG_3); disp('3 Test MA')
save('subject3e.mat', 'sub_3_glove_FD'); clear s*
sub_3_test_FD = MovingFreqDomain(Test_ECoG_3); disp('3 Test FD')
save('subject3f.mat', 'sub_3_test_FD'); clear s*

