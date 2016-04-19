%% Student-divided Section; Import Data
% Importing Data
clear all;
close all;
addpath(genpath('c:/Users/sungm/ieeg-matlab-1.13.2'));
session1_Train_ECoG = IEEGSession('I521_A0012_D001', 'hasm', 'has_ieeglogin.bin');
session1_Train_Glove = IEEGSession('I521_A0012_D002', 'hasm', 'has_ieeglogin.bin');
session1_Test_ECoG = IEEGSession('I521_A0012_D003', 'hasm', 'has_ieeglogin.bin');

session2_Train_ECoG = IEEGSession('I521_A0013_D001', 'hasm', 'has_ieeglogin.bin');
session2_Train_Glove = IEEGSession('I521_A0013_D002', 'hasm', 'has_ieeglogin.bin');
session2_Test_ECoG = IEEGSession('I521_A0013_D003', 'hasm', 'has_ieeglogin.bin');

session3_Train_ECoG = IEEGSession('I521_A0014_D001', 'hasm', 'has_ieeglogin.bin');
session3_Train_Glove = IEEGSession('I521_A0014_D002', 'hasm', 'has_ieeglogin.bin');
session3_Test_ECoG = IEEGSession('I521_A0014_D003', 'hasm', 'has_ieeglogin.bin');

% Train_ECoG_1_array = cell(1, length(session1_Train_ECoG.data.rawChannels));
Train_ECoG_1 = ones((ceil((session1_Train_ECoG.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session1_Train_ECoG.data.rawChannels(1).sampleRate)), length(session1_Train_ECoG.data.rawChannels)) .* -1;
for index = 1:1:length(session1_Train_ECoG.data.rawChannels)
    nr = ceil((session1_Train_ECoG.data.rawChannels(index).get_tsdetails.getEndTime)/(1e6)*session1_Train_ECoG.data.rawChannels(index).sampleRate);
%     Train_ECoG_1_array{index} = session1_Train_ECoG.data.getvalues(1:(nr), index:index);
    Train_ECoG_1(:, index) = session1_Train_ECoG.data.getvalues(1:(nr), index:index)';
end

Train_Glove_1 = ones((ceil((session1_Train_Glove.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session1_Train_Glove.data.rawChannels(1).sampleRate)), length(session1_Train_Glove.data.rawChannels)) .* -1;
for index = 1:1:length(session1_Train_Glove.data.rawChannels)
    nr = ceil((session1_Train_Glove.data.rawChannels(index).get_tsdetails.getEndTime)/(1e6)*session1_Train_Glove.data.rawChannels(index).sampleRate);
    Train_Glove_1(:, index) = session1_Train_Glove.data.getvalues(1:(nr), index:index)';
end

Test_ECoG_1 = ones((ceil((session1_Test_ECoG.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session1_Test_ECoG.data.rawChannels(1).sampleRate)), length(session1_Test_ECoG.data.rawChannels)) .* -1;
for index = 1:1:length(session1_Test_ECoG.data.rawChannels)
    nr = ceil((session1_Test_ECoG.data.rawChannels(index).get_tsdetails.getEndTime)/(1e6)*session1_Test_ECoG.data.rawChannels(index).sampleRate);
    Test_ECoG_1(:, index) = session1_Test_ECoG.data.getvalues(1:(nr), index:index)';
end

Train_ECoG_2 = ones((ceil((session2_Train_ECoG.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session2_Train_ECoG.data.rawChannels(1).sampleRate)), length(session2_Train_ECoG.data.rawChannels)) .* -1;
for index = 1:1:length(session2_Train_ECoG.data.rawChannels)
    nr = ceil((session2_Train_ECoG.data.rawChannels(index).get_tsdetails.getEndTime)/(1e6)*session2_Train_ECoG.data.rawChannels(index).sampleRate);
%     Train_ECoG_2_array{index} = session2_Train_ECoG.data.getvalues(1:(nr), index:index);
    Train_ECoG_2(:, index) = session2_Train_ECoG.data.getvalues(1:(nr), index:index)';
end

Train_Glove_2 = ones((ceil((session2_Train_Glove.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session2_Train_Glove.data.rawChannels(1).sampleRate)), length(session2_Train_Glove.data.rawChannels)) .* -1;
for index = 1:1:length(session2_Train_Glove.data.rawChannels)
    nr = ceil((session2_Train_Glove.data.rawChannels(index).get_tsdetails.getEndTime)/(1e6)*session2_Train_Glove.data.rawChannels(index).sampleRate);
    Train_Glove_2(:, index) = session2_Train_Glove.data.getvalues(1:(nr), index:index)';
end

Test_ECoG_2 = ones((ceil((session2_Test_ECoG.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session2_Test_ECoG.data.rawChannels(1).sampleRate)), length(session2_Test_ECoG.data.rawChannels)) .* -1;
for index = 1:1:length(session2_Test_ECoG.data.rawChannels)
    nr = ceil((session2_Test_ECoG.data.rawChannels(index).get_tsdetails.getEndTime)/(1e6)*session2_Test_ECoG.data.rawChannels(index).sampleRate);
    Test_ECoG_2(:, index) = session2_Test_ECoG.data.getvalues(1:(nr), index:index)';
end

Train_ECoG_3 = ones((ceil((session3_Train_ECoG.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session3_Train_ECoG.data.rawChannels(1).sampleRate)), length(session3_Train_ECoG.data.rawChannels)) .* -1;
for index = 1:1:length(session3_Train_ECoG.data.rawChannels)
    nr = ceil((session3_Train_ECoG.data.rawChannels(index).get_tsdetails.getEndTime)/(1e6)*session3_Train_ECoG.data.rawChannels(index).sampleRate);
%     Train_ECoG_3_array{index} = session3_Train_ECoG.data.getvalues(1:(nr), index:index);
    Train_ECoG_3(:, index) = session3_Train_ECoG.data.getvalues(1:(nr), index:index)';
end

Train_Glove_3 = ones((ceil((session3_Train_Glove.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session3_Train_Glove.data.rawChannels(1).sampleRate)), length(session3_Train_Glove.data.rawChannels)) .* -1;
for index = 1:1:length(session3_Train_Glove.data.rawChannels)
    nr = ceil((session3_Train_Glove.data.rawChannels(index).get_tsdetails.getEndTime)/(1e6)*session3_Train_Glove.data.rawChannels(index).sampleRate);
    Train_Glove_3(:, index) = session3_Train_Glove.data.getvalues(1:(nr), index:index)';
end

Test_ECoG_3 = ones((ceil((session3_Test_ECoG.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session3_Test_ECoG.data.rawChannels(1).sampleRate)), length(session3_Test_ECoG.data.rawChannels)) .* -1;
for index = 1:1:length(session3_Test_ECoG.data.rawChannels)
    nr = ceil((session3_Test_ECoG.data.rawChannels(index).get_tsdetails.getEndTime)/(1e6)*session3_Test_ECoG.data.rawChannels(index).sampleRate);
    Test_ECoG_3(:, index) = session3_Test_ECoG.data.getvalues(1:(nr), index:index)';
end

%% Importing from Git local folder

