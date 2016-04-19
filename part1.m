username = 'brwr';
password_bin = '~/Downloads/BCI/brw_ieeglogin.bin';

% SUBJECT 1
% Training ECoG
session_1_train = IEEGSession('I521_A0012_D001', username, password_bin);
% Training Data Glove
session_1_glove = IEEGSession('I521_A0012_D002', username, password_bin);
% Testing ECoG
session_1_test = IEEGSession('I521_A0012_D003', username, password_bin);

% SUBJECT 2
% Training ECoG
session_2_train = IEEGSession('I521_A0013_D001', username, password_bin);
% Training Data Glove
session_2_glove = IEEGSession('I521_A0013_D002', username, password_bin);
% Testing ECoG
session_2_test = IEEGSession('I521_A0013_D003', username, password_bin);

% SUBJECT 3
% Training ECoG
session_3_train = IEEGSession('I521_A0014_D001', username, password_bin);
% Training Data Glove
session_3_glove = IEEGSession('I521_A0014_D002', username, password_bin);
% Testing ECoG
session_3_test = IEEGSession('I521_A0014_D003', username, password_bin);

% TODO(brwr): Replace hard-coded numbers with variables using IEEG object size
data_1_train = session_1_train.data.getvalues(1 : 310000, 1 : 62);
