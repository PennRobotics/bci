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

sub1_total_final = [sub_1_train_MA , sub_1_train_FD];
% sub_1_test_final = [sub_1_test_MA , sub_1_test_FD];

sub2_total_final = [sub_2_train_MA , sub_2_train_FD];
% sub_2_test_final = [sub_2_test_MA , sub_2_test_FD];

sub3_total_final = [sub_3_train_MA , sub_3_train_FD];
% sub_3_test_final = [sub_3_test_MA , sub_3_test_FD];

for j = 1:5
     sub1_glove_total_decimated(:, j) = decimate(Train_Glove_1(:, j), 50);
     sub2_glove_total_decimated(:, j) = decimate(Train_Glove_2(:, j), 50);
     sub3_glove_total_decimated(:, j) = decimate(Train_Glove_3(:, j), 50);
end

% Remove channel 55 from subject 1 dataset
% TODO(brwr): Make sure this works properly!
% sub_1_train_final(:, 55) = [];
% sub_1_test_final(:, 55) = [];

clear sub_1_train_MA sub_1_train_FD sub_2_train_MA sub_2_train_FD sub_3_train_MA sub_3_train_FD
clear sub_1_test* sub_2_test* sub_3_test*
clear Test_ECoG*
N = 3; % Number of delays

% disp('1/3  Generating Full R Matrices')
% R1_full = GenerateRMatrix(sub_1_train_final, N);
% disp('2/3')
% R2_full = GenerateRMatrix(sub_2_train_final, N);
% disp('3/3')
% R3_full = GenerateRMatrix(sub_3_train_final, N);
disp('1/3  Generating Full R Matrices')
R1_total = GenerateRMatrix(sub1_total_final, N);
disp('2/3')
R2_total = GenerateRMatrix(sub2_total_final, N);
disp('3/3')
R3_total = GenerateRMatrix(sub3_total_final, N);


% R1 = R1_full(1 + N : end - N, :);
% R2 = R2_full(1 + N : end - N, :);
% R3 = R3_full(1 + N : end - N, :);
% R1 = R1_full;
% R2 = R2_full;
% R3 = R3_full;

% clear R1_full R2_full R3_full;
%% CROSS-VALIDATION INDEXING
percentSample = 0.5;

rng(159159);

total_index = N : length(sub1_total_final);
train_index = randsample(total_index, round(length(total_index) * percentSample));
test_index = total_index;
test_index( (train_index + (-N + 1) ) ) = [];
% test_index = test_index(N:end);
% train_index = train_index(N:end);
train_index = sort(train_index);
test_index = sort(test_index);


sub1_train_final = sub1_total_final(train_index, :);
sub1_test_final = sub1_total_final(test_index, :);
sub1_train_glove = sub1_glove_total_decimated(train_index, :);
sub1_test_glove = sub1_glove_total_decimated(test_index, :);

sub2_train_final = sub2_total_final(train_index, :);
sub2_test_final = sub2_total_final(test_index, :);
sub2_train_glove = sub2_glove_total_decimated(train_index, :);
sub2_test_glove = sub2_glove_total_decimated(test_index, :);

sub3_train_final = sub3_total_final(train_index, :);
sub3_test_final = sub3_total_final(test_index, :);
sub3_train_glove = sub3_glove_total_decimated(train_index, :);
sub3_test_glove = sub3_glove_total_decimated(test_index, :);

sub1_train_final = sub1_train_final(N:end, :);
sub1_test_final = sub1_test_final(N:end, :);
sub1_train_glove = sub1_train_glove(N:end, :);
sub1_test_glove = sub1_test_glove(N:end, :);

sub2_train_final = sub2_train_final(N:end, :);
sub2_test_final = sub2_test_final(N:end ,:);
sub2_train_glove = sub2_train_glove(N:end, :);
sub2_test_glove = sub2_test_glove(N:end, :);

sub3_train_final = sub3_train_final(N:end, :);
sub3_test_final = sub3_test_final(N:end, :);
sub3_train_glove = sub3_train_glove(N:end, :);
sub3_test_glove = sub3_test_glove(N:end, :);
% 
% sub1_total_glove = sub1_glove_total_decimated;
% sub2_total_glove = sub2_glove_total_decimated;
% sub3_total_glove = sub3_glove_total_decimated;


disp('Splitting R Matrix into train and test R matricies')
R1_train = R1_total(train_index(1:end-N+1), :);
R1_test = R1_total(test_index(1:end-N+1), :);
R2_train = R2_total(train_index(1:end-N+1), :);
R2_test = R2_total(test_index(1:end-N+1), :);
R3_train = R3_total(train_index(1:end-N+1), :);
R3_test = R3_total(test_index(1:end-N+1), :);

% 
% sub1_test_final = sub1_train_final(train_xval_index, :);
% sub1_train_final(train_xval_index, :) = [];
% sub1_glove_test_decimated = sub1_glove_decimated(train_xval_index, :);
% sub1_glove_train_decimated(train_xval_index, :) = [];
% 
% sub_2_train_xval = sub_2_train_final(train_xval_index, :);
% sub_2_train_final(train_xval_index, :) = [];
% sub2_glove_xval = sub2_glove_decimated(train_xval_index, :);
% sub2_glove_decimated(train_xval_index, :) = [];
% 
% sub_3_train_xval = sub_3_train_final(train_xval_index, :);
% sub_3_train_final(train_xval_index, :) = [];
% sub3_glove_xval = sub3_glove_decimated(train_xval_index, :);
% sub3_glove_decimated(train_xval_index, :) = [];


%% PROCESS DATA
Y1 = sub1_glove_total_decimated(1 : end, :);
Y2 = sub2_glove_total_decimated(1 : end, :);
Y3 = sub3_glove_total_decimated(1 : end, :);
Y_train1 = sub1_train_glove(1 : end, :); 
Y_train2 = sub2_train_glove(1 : end, :); 
Y_train3 = sub3_train_glove(1 : end, :); 
Y_test1 = sub1_test_glove(1 : end, :);
Y_test2 = sub2_test_glove(1 : end, :);
Y_test3 = sub3_test_glove(1 : end, :);
% Y1 = sub1_total_glove(N : end, :);
% Y2 = sub2_total_glove(N : end, :);
% Y3 = sub3_total_glove(N : end, :);
% Y_train1 = sub1_train_glove(N : end, :); 
% Y_train2 = sub2_train_glove(N : end, :); 
% Y_train3 = sub3_train_glove(N : end, :); 
% Y_test1 = sub1_test_glove(N : end, :);
% Y_test2 = sub2_test_glove(N : end, :);
% Y_test3 = sub3_test_glove(N : end, :);

% Y1 = sub1_glove_decimated(N : end, :);
% Y2 = sub2_glove_decimated(N : end, :);
% Y3 = sub3_glove_decimated(N : end, :);




%% CROSS-VALIDATION
% disp('1/3  Generating Cross-Validation Train R Matrices');
% R1_XV = GenerateRMatrix(sub_1_train_xval, N);
% disp('2/3')
% R2_XV = GenerateRMatrix(sub_2_train_xval, N);
% disp('3/3')
% R3_XV = GenerateRMatrix(sub_3_train_xval, N);
% 
% disp('1/3  Generating Cross-Validation Train R Matrices');
% R1_train = GenerateRMatrix(sub1_train_final, N);
% disp('2/3')
% R2_train = GenerateRMatrix(sub2_train_final, N);
% disp('3/3')
% R3_train = GenerateRMatrix(sub3_train_final, N);
% 
disp('Linear Regression')
beta1 = (R1_train' * R1_train) \ (R1_train' * Y_train1);
beta2 = (R2_train' * R2_train) \ (R2_train' * Y_train2);
beta3 = (R3_train' * R3_train) \ (R3_train' * Y_train3);


% XV1 = R1_XV(1 + N : end - N, :); 
% XV2 = R2_XV(1 + N : end - N, :); 
% XV3 = R3_XV(1 + N : end - N, :); 
% Xtrain1 = R1_train;
% Xtrain2 = R2_train;
% Xtrain3 = R3_train;


Y_test1_hat = R1_test * beta1;
Y_test2_hat = R2_test * beta2;
Y_test3_hat = R3_test * beta3;

smooth_scan = 101;
% Smoothing
for finger = 1:1:5
    Y_test1_hat(:, finger) = smooth(Y_test1_hat(:, finger), smooth_scan);
    Y_test2_hat(:, finger) = smooth(Y_test2_hat(:, finger), smooth_scan);
    Y_test3_hat(:, finger) = smooth(Y_test3_hat(:, finger), smooth_scan);
end
% 
% Y_test1_hat_final = [repmat(Y_test1_hat(1, :),N,1); Y_test1_hat; repmat(Y_test1_hat(end, :),N,1)];
% Y_test2_hat_final = [repmat(Y_test2_hat(1, :),N,1); Y_test2_hat; repmat(Y_test2_hat(end, :),N,1)];
% Y_test3_hat_final = [repmat(Y_test3_hat(1, :),N,1); Y_test3_hat; repmat(Y_test3_hat(end, :),N,1)];
% YV1_Final = [repmat(YV1_hat(1, :),N,1); YV1_hat];
% YV2_Final = [repmat(YV2_hat(1, :),N,1); YV2_hat];
% YV3_Final = [repmat(YV3_hat(1, :),N,1); YV3_hat];
% 
% L1 = size(Y_test1_hat_final, 1);
% L2 = size(Y_test2_hat_final, 1);
% L3 = size(Y_test3_hat_final, 1);
% 
% disp('Cross-Validation PCHIP Stage 1/2')
% YYxval1 = pchip(linspace(0, L1, size(Y_test1_hat_final, 1)), Y_test1_hat_final', linspace(0, L1, L1))';
% YYxval2 = pchip(linspace(0, L2, size(Y_test2_hat_final, 1)), Y_test2_hat_final', linspace(0, L2, L2))';
% YYxval3 = pchip(linspace(0, L3, size(Y_test3_hat_final, 1)), Y_test3_hat_final', linspace(0, L3, L3))';
% YYV1a = pchip(0 : 50 : L1 - 1, YV1_Final', (0 : 10 : L1 - 1))';
% YYV2a = pchip(0 : 50 : L2 - 1, YV2_Final', (0 : 10 : L2 - 1))';
% YYV3a = pchip(0 : 50 : L3 - 1, YV3_Final', (0 : 10 : L3 - 1))';
% 
% disp('Cross-Validation PCHIP Stage 2/2')
% YYxval1 = pchip(0 : 10 : L1 - 1, YYV1a', (0 : L1 - 1))';
% YYxval2 = pchip(0 : 10 : L2 - 1, YYV2a', (0 : L2 - 1))';
% YYxval3 = pchip(0 : 10 : L3 - 1, YYV3a', (0 : L3 - 1))';
% 
% Y1_xval = sub1_test_glove;
% Y2_xval = sub2_test_glove;
% Y3_xval = sub3_test_glove;

c1 = corr(Y_test1, Y_test1_hat);
c2 = corr(Y_test2, Y_test2_hat);
c3 = corr(Y_test3, Y_test3_hat);

for subject = 1:1:3
    for finger = 1:1:5
        figure
        hold on;
        titlestring = sprintf('Subject %d, finger %d', subject, finger);
        title(titlestring);
        if (subject == 1)
            Y_test = Y_test1;
            Y_test_hat = Y_test1_hat;
        elseif (subject == 2)
            Y_test = Y_test2;
            Y_test_hat = Y_test2_hat;
        elseif (subject == 3)
            Y_test = Y_test3;
            Y_test_hat = Y_test3_hat;
        end
        plot(Y_test(:, finger), 'r');
        plot(Y_test_hat(:, finger), 'b');
        legend('actual', 'fit');
        hold off;m
    end
end

% %% TEST
% disp('1/3  Generating Testing R Matrices')
% R1_X = GenerateRMatrix(sub_1_test_final, N);
% disp('2/3')
% R2_X = GenerateRMatrix(sub_2_test_final, N);
% disp('3/3')
% R3_X = GenerateRMatrix(sub_3_test_final, N);
% 
% X1 = R1_X(1 + N : end - N, :); 
% X2 = R2_X(1 + N : end - N, :); 
% X3 = R3_X(1 + N : end - N, :); 
% 
% Y1_hat = X1 * beta1;
% Y2_hat = X2 * beta2;
% Y3_hat = X3 * beta3;
% 
% Y1_Final = [repmat(Y1_hat(1, :),N,1); Y1_hat; repmat(Y1_hat(end, :),N,1)];
% Y2_Final = [repmat(Y2_hat(1, :),N,1); Y2_hat; repmat(Y2_hat(end, :),N,1)];
% Y3_Final = [repmat(Y3_hat(1, :),N,1); Y3_hat; repmat(Y3_hat(end, :),N,1)];
% 
% L1 = size(Test_ECoG_1, 1);
% L2 = size(Test_ECoG_2, 1);
% L3 = size(Test_ECoG_3, 1);
% 
% % disp('Output Spline')
% % YY1 = spline(0 : 50 : L1 - 1, Y1_Final', (0 : L1 - 1))';
% % YY2 = spline(0 : 50 : L2 - 1, Y2_Final', (0 : L2 - 1))';
% % YY3 = spline(0 : 50 : L3 - 1, Y3_Final', (0 : L3 - 1))';
% 
% % disp('Output PCHIP')
% % YY1 = pchip(0 : 50 : L1 - 1, Y1_Final', (0 : L1 - 1))';
% % YY2 = pchip(0 : 50 : L2 - 1, Y2_Final', (0 : L2 - 1))';
% % YY3 = pchip(0 : 50 : L3 - 1, Y3_Final', (0 : L3 - 1))';
% 
% disp('Output PCHIP Stage 1/2')
% YY1a = pchip(0 : 50 : L1 - 1, Y1_Final', (0 : 10 : L1 - 1))';
% YY2a = pchip(0 : 50 : L2 - 1, Y2_Final', (0 : 10 : L2 - 1))';
% YY3a = pchip(0 : 50 : L3 - 1, Y3_Final', (0 : 10 : L3 - 1))';
% 
% disp('Output PCHIP Stage 2/2')
% YY1 = pchip(0 : 10 : L1 - 1, YY1a', (0 : L1 - 1))';
% YY2 = pchip(0 : 10 : L2 - 1, YY2a', (0 : L2 - 1))';
% YY3 = pchip(0 : 10 : L3 - 1, YY3a', (0 : L3 - 1))';
% 
% predicted_dg{1} = YY1;
% predicted_dg{2} = YY2;
% predicted_dg{3} = YY3;
% 
% disp('Saving axon_fired.mat')
% save('axon_fired.mat', 'predicted_dg');
% 
% disp('Done.')
% disp(' ')
% disp(' ')
% 
