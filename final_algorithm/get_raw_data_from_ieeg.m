%% DOWNLOAD FROM IEEG
disp('Getting data from IEEG.org')

clear all
username = 'brwr';
password_bin = '~/Downloads/BCI/brw_ieeglogin.bin';

subject1 = true;
subject2 = true;
subject3 = true;

%% SUBJECT 1 (Training ECoG, Training Glove, Testing ECoG)
if subject1
  session_1_train = IEEGSession('I521_A0012_D001', username, password_bin);
  session_1_glove = IEEGSession('I521_A0012_D002', username, password_bin);
  session_1_test  = IEEGSession('I521_A0012_D003', username, password_bin);
end

%% SUBJECT 2
if subject2
  session_2_train = IEEGSession('I521_A0013_D001', username, password_bin);
  session_2_glove = IEEGSession('I521_A0013_D002', username, password_bin);
  session_2_test  = IEEGSession('I521_A0013_D003', username, password_bin);
end

%% SUBJECT 3
if subject3
  session_3_train = IEEGSession('I521_A0014_D001', username, password_bin);
  session_3_glove = IEEGSession('I521_A0014_D002', username, password_bin);
  session_3_test  = IEEGSession('I521_A0014_D003', username, password_bin);
end

nr_1_train    = session_1_train.data.rawChannels(1).getNrSamples + 1;%<rows>
nr_1_glove    = session_1_glove.data.rawChannels(1).getNrSamples + 1;
nr_1_test     = session_1_test .data.rawChannels(1).getNrSamples + 1;
nc_1_train    = length(session_1_train.data.rawChannels); % <cols>
nc_1_glove    = length(session_1_glove.data.rawChannels);
nc_1_test     = length(session_1_test .data.rawChannels);
Train_ECoG_1  = session_1_train.data.getvalues(1:nr_1_train, 1:nc_1_train);
Train_Glove_1 = session_1_glove.data.getvalues(1:nr_1_glove, 1:nc_1_glove);
Test_ECoG_1   = session_1_test .data.getvalues(1:nr_1_test , 1:nc_1_test );

nr_2_train    = session_2_train.data.rawChannels(1).getNrSamples + 1;
nr_2_glove    = session_2_glove.data.rawChannels(1).getNrSamples + 1;
nr_2_test     = session_2_test .data.rawChannels(1).getNrSamples + 1;
nc_2_train    = length(session_2_train.data.rawChannels);
nc_2_glove    = length(session_2_glove.data.rawChannels);
nc_2_test     = length(session_2_test .data.rawChannels);
Train_ECoG_2  = session_2_train.data.getvalues(1:nr_2_train, 1:nc_2_train);
Train_Glove_2 = session_2_glove.data.getvalues(1:nr_2_glove, 1:nc_2_glove);
Test_ECoG_2   = session_2_test .data.getvalues(1:nr_2_test , 1:nc_2_test );

nr_3_train    = session_3_train.data.rawChannels(1).getNrSamples + 1;
nr_3_glove    = session_3_glove.data.rawChannels(1).getNrSamples + 1;
nr_3_test     = session_3_test .data.rawChannels(1).getNrSamples + 1;
nc_3_train    = length(session_3_train.data.rawChannels);
nc_3_glove    = length(session_3_glove.data.rawChannels);
nc_3_test     = length(session_3_test .data.rawChannels);
Train_ECoG_3  = session_3_train.data.getvalues(1:nr_3_train, 1:nc_3_train);
Train_Glove_3 = session_3_glove.data.getvalues(1:nr_3_glove, 1:nc_3_glove);
Test_ECoG_3   = session_3_test .data.getvalues(1:nr_3_test , 1:nc_3_test );

disp('Saving subject data to matfiles')
save('subject1.mat', 'Train_ECoG_1', 'Train_Glove_1', 'Test_ECoG_1');
save('subject2.mat', 'Train_ECoG_2', 'Train_Glove_2', 'Test_ECoG_2');
save('subject3.mat', 'Train_ECoG_3', 'Train_Glove_3', 'Test_ECoG_3');

clear all % free up some workspace memory