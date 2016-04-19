username = 'brwr';
password_bin = '~/Downloads/BCI/brw_ieeglogin.bin';

% SUBJECT 1
% Training ECoG
data_1_train = IEEGSession('I521_A0012_D001', username, password_bin);
% Training Data Glove
data_1_glove = IEEGSession('I521_A0012_D002', username, password_bin);
% Testing ECoG
data_1_test = IEEGSession('I521_A0012_D003', username, password_bin);

% SUBJECT 2
% Training ECoG
data_2_train = IEEGSession('I521_A0013_D001', username, password_bin);
% Training Data Glove
data_2_glove = IEEGSession('I521_A0013_D002', username, password_bin);
% Testing ECoG
data_2_test = IEEGSession('I521_A0013_D003', username, password_bin);

% SUBJECT 3
% Training ECoG
data_3_train = IEEGSession('I521_A0014_D001', username, password_bin);
% Training Data Glove
data_3_glove = IEEGSession('I521_A0014_D002', username, password_bin);
% Testing ECoG
data_3_test = IEEGSession('I521_A0014_D003', username, password_bin);

