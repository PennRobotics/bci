%% PROCESS RAW DATA
%  This function ...
%  ... Constructs features from transient data
%  ... Filters signals deemed improper
disp('Processing Raw Data')

%% VARIABLES
clear all

Ts =  50;  % Sample period [ms]
Tw = 250;  % Window duration [ms]
N  =   3;  % (Num Delays) Number of subsequent samples to concatenate

%% FEATURE GENERATION
disp('Loading Subject Raw Features')
load subject1
load subject2
load subject3

disp('Removing Channel 55 from Subject 1')
Train_ECoG_1(:, 55) = [];
Test_ECoG_1 (:, 55) = [];

disp('Generating New Features')
sub_1_train_MA = FnMovingAverageAdj(Train_ECoG_1, Ts, Tw); disp('1 Train MA')
sub_1_train_FD = FnMovingFreqDomAdj(Train_ECoG_1, Ts, Tw); disp('1 Train FD')
sub_1_test_MA  = FnMovingAverageAdj( Test_ECoG_1, Ts, Tw); disp('1 Test  MA')
sub_1_test_FD  = FnMovingFreqDomAdj( Test_ECoG_1, Ts, Tw); disp('1 Test  FD')

sub_2_train_MA = FnMovingAverageAdj(Train_ECoG_2, Ts, Tw); disp('2 Train MA')
sub_2_train_FD = FnMovingFreqDomAdj(Train_ECoG_2, Ts, Tw); disp('2 Train FD')
sub_2_test_MA  = FnMovingAverageAdj( Test_ECoG_2, Ts, Tw); disp('2 Test  MA')
sub_2_test_FD  = FnMovingFreqDomAdj( Test_ECoG_2, Ts, Tw); disp('2 Test  FD')

sub_3_train_MA = FnMovingAverageAdj(Train_ECoG_3, Ts, Tw); disp('3 Train MA')
sub_3_train_FD = FnMovingFreqDomAdj(Train_ECoG_3, Ts, Tw); disp('3 Train FD')
sub_3_test_MA  = FnMovingAverageAdj( Test_ECoG_3, Ts, Tw); disp('3 Test  MA')
sub_3_test_FD  = FnMovingFreqDomAdj( Test_ECoG_3, Ts, Tw); disp('3 Test  FD')

sub_1_glove_decimated = FnMovingAverageAdj(Train_Glove_1,Ts,Tw);disp('1 Glove')
sub_2_glove_decimated = FnMovingAverageAdj(Train_Glove_2,Ts,Tw);disp('2 Glove')
sub_3_glove_decimated = FnMovingAverageAdj(Train_Glove_3,Ts,Tw);disp('3 Glove')

disp('Concatenate Subject Features')
sub_1_train_final = [sub_1_train_MA , sub_1_train_FD];
sub_1_test_final = [sub_1_test_MA , sub_1_test_FD];

sub_2_train_final = [sub_2_train_MA , sub_2_train_FD];
sub_2_test_final = [sub_2_test_MA , sub_2_test_FD];

sub_3_train_final = [sub_3_train_MA , sub_3_train_FD];
sub_3_test_final = [sub_3_test_MA , sub_3_test_FD];
