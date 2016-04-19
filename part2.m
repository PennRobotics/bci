clear all

load subject1
load subject2
load subject3

sub_1_train_part = Train_ECoG_1(1:50000, 16:31);
sub_2_train_part = Train_ECoG_2(1:50000, 16:31);
sub_3_train_part = Train_ECoG_3(1:50000, 16:31);

sub_1_glove_part = Train_Glove_1(1:50000, 1:5);
sub_2_glove_part = Train_Glove_2(1:50000, 1:5);
sub_3_glove_part = Train_Glove_3(1:50000, 1:5);

sub_1_test_part = Test_ECoG_1(1:50000, 16:31);
sub_2_test_part = Test_ECoG_2(1:50000, 16:31);
sub_3_test_part = Test_ECoG_3(1:50000, 16:31);

clear T*

sub_1_train_part_MA = MovingAverage(sub_1_train_part);
sub_2_train_part_MA = MovingAverage(sub_2_train_part);
sub_3_train_part_MA = MovingAverage(sub_3_train_part);

sub_1_glove_part_MA = MovingAverage(sub_1_glove_part);
sub_2_glove_part_MA = MovingAverage(sub_2_glove_part);
sub_3_glove_part_MA = MovingAverage(sub_3_glove_part);

sub_1_test_part_MA = MovingAverage(sub_1_test_part);
sub_2_test_part_MA = MovingAverage(sub_2_test_part);
sub_3_test_part_MA = MovingAverage(sub_3_test_part);

