% TODO(brwr): 50 is hard-coded

%% WARNING: DO NOT RUN ENTIRE CODE; 15 Lasso beta calculations will run and take extremely long time
% Run line by line or section by section!!

%%
clear all

disp('Loading Subject Raw Features')
load subject1
load subject2
load subject3

%% Commented out; faster to load data from directory
% 
% disp('Generating New Features')
% % sub_1_train_MA = MovingAverage(Train_ECoG_1); disp('1 Train MA')
% % save('subject1a.mat', 'sub_1_train_MA'); % clear s*
%  sub_1_train_FD = MovingFreqDomain(Train_ECoG_1); disp('1 Train FD')
%  save('subject1b.mat', 'sub_1_train_FD'); %clear s*
% % % sub_1_glove_MA = MovingAverage(Train_Glove_1); disp('1 Glove MA')
% % % save('subject1c.mat', 'sub_1_glove_MA'); %clear s*
% % % sub_1_glove_FD = MovingFreqDomain(Train_Glove_1); disp('1 Glove FD')
% % % save('subject1d.mat', 'sub_1_glove_FD'); %clear s*
% % sub_1_test_MA = MovingAverage(Test_ECoG_1); disp('1 Test MA')
% % save('subject1e.mat', 'sub_1_test_MA'); %clear s*
%  sub_1_test_FD = MovingFreqDomain(Test_ECoG_1); disp('1 Test FD')
%  save('subject1f.mat', 'sub_1_test_FD'); %clear s*
% 
% % sub_2_train_MA = MovingAverage(Train_ECoG_2); disp('2 Train MA')
% % save('subject2a.mat', 'sub_2_train_MA'); clear s*
%  sub_2_train_FD = MovingFreqDomain(Train_ECoG_2); disp('2 Train FD')
%  save('subject2b.mat', 'sub_2_train_FD'); clear s*
% % % sub_2_glove_MA = MovingAverage(Train_Glove_2); disp('2 Glove MA')
% % % save('subject2c.mat', 'sub_2_glove_MA'); clear s*
% % % sub_2_glove_FD = MovingFreqDomain(Train_Glove_2); disp('2 Glove FD')
% % % save('subject2d.mat', 'sub_2_glove_FD'); clear s*
% % sub_2_test_MA = MovingAverage(Test_ECoG_2); disp('2 Test MA')
% % save('subject2e.mat', 'sub_2_test_MA'); clear s*
%  sub_2_test_FD = MovingFreqDomain(Test_ECoG_2); disp('2 Test FD')
%  save('subject2f.mat', 'sub_2_test_FD'); clear s*
% 
% % sub_3_train_MA = MovingAverage(Train_ECoG_3); disp('3 Train MA')
% % save('subject3a.mat', 'sub_3_train_MA'); clear s*
%  sub_3_train_FD = MovingFreqDomain(Train_ECoG_3); disp('3 Train FD')
%  save('subject3b.mat', 'sub_3_train_FD'); clear s*
% % % sub_3_glove_MA = MovingAverage(Train_Glove_3); disp('3 Glove MA')
% % % save('subject3c.mat', 'sub_3_glove_MA'); clear s*
% % % sub_3_glove_FD = MovingFreqDomain(Train_Glove_3); disp('3 Glove FD')
% % % save('subject3d.mat', 'sub_3_glove_FD'); clear s*
% % sub_3_test_MA = MovingAverage(Test_ECoG_3); disp('3 Test MA')
% % save('subject3e.mat', 'sub_3_test_MA'); clear s*
%  sub_3_test_FD = MovingFreqDomain(Test_ECoG_3); disp('3 Test FD')
%  save('subject3f.mat', 'sub_3_test_FD'); clear s*

%% Instead of calculating data as above, use this load for pre-calculated matrices

disp('Loading Subject Features')
load subject1a; load subject1b; load subject1e; load subject1f;
load subject2a; load subject2b; load subject2e; load subject2f;
load subject3a; load subject3b; load subject3e; load subject3f;

%% Inputs

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

% Remove channel 55 from subject 1 dataset
% TODO(brwr): Make sure this works properly!
sub_1_train_final(:, 55) = [];
sub_1_test_final(:, 55) = [];

disp('1/3  Generating Training R Matrices')
R1_full = GenerateRMatrix(sub_1_train_final, N);
disp('2/3')
R2_full = GenerateRMatrix(sub_2_train_final, N);
disp('3/3')
R3_full = GenerateRMatrix(sub_3_train_final, N);

R1 = R1_full(1 + N : end - N, :);
R2 = R2_full(1 + N : end - N, :);
R3 = R3_full(1 + N : end - N, :);

Y1 = sub1_glove_decimated(1 + N : end - N, :);
Y2 = sub2_glove_decimated(1 + N : end - N, :);
Y3 = sub3_glove_decimated(1 + N : end - N, :);
%% Don't run this if you want LASSO
% disp('Linear Regression')
% beta1 = (R1' * R1) \ R1' * Y1;
% beta2 = (R2' * R2) \ R2' * Y2;
% beta3 = (R3' * R3) \ R3' * Y3;

%% 
disp('LASSO with default setting')

%lasso takes in Y(corresponding Y postion only as a vector at a time), so
%cell arrays were used to assign correct beta to each finger
NumLambda = 100;
beta1 = zeros(size(R1, 2), NumLambda, size(Y1, 2));
fitinfo1 = cell(5, 1);
beta2 = zeros(size(R2, 2), NumLambda, size(Y2, 2));
fitinfo2 = cell(5, 1);
beta3 = zeros(size(R3, 2), NumLambda, size(Y3, 2));
fitinfo3 = cell(5, 1);

%actually run lasso
%WARNING: Will take long time!
for finger = 1:1:size(Y1, 2)
    [beta, fitinfo] = lasso(R1, Y1(:, finger));
    beta1(:, :, finger) = beta;
    fitinfo1{finger} = fitinfo;
    sprintf('\nFinished %d-th finger, subject1', finger)
end

for finger = 1:1:size(Y2, 2)
    [beta, fitinfo] = lasso(R2, Y2(:, finger));
    beta2(:, :, finger) = beta;
    fitinfo2{finger} = fitinfo;
    sprintf('\nFinished %d-th finger, subject2', finger)
end

for finger = 1:1:size(Y3, 2)
    [beta, fitinfo] = lasso(R3, Y3(:, finger));
    beta3(:, :, finger) = beta;
    fitinfo3{finger} = fitinfo;
    sprintf('\nFinished %d-th finger, subject3', finger)
end

%% Getting the best fit column among NumLambda = 100 for each subject
min_mse = ones(3, size(Y1, 2)) .* 9e99;
best_index = zeros(3, size(Y1, 2));
for subject = 1:1:3
    if subject == 1
        fitinfo = fitinfo1;
    elseif subject == 2
        fitinfo = fitinfo2;
    elseif subject == 3
        fitinfo = fitinfo3;
    else
        disp('error')
        break;
    end
    
    for finger = 1:1:size(Y1, 2)
%         fitinfo_finger = fitinfo{finger};
        fitinfo_mse = fitinfo{finger}.MSE;
        for index = 1:1:length(fitinfo_mse)
            sprintf('\nChecking %d subject, finger %d/5, index %d/100', subject, finger, index)
            if fitinfo_mse(index) < min_mse(subject, finger)
                sprintf('\nSUCCSS for %d subject, finger %d/5, index %d/100', subject, finger, index)
                min_mse(subject, finger) = fitinfo_mse(index);
                best_index(subject, finger) = index;
            end
        end
    end
end

%%
disp('1/3  Generating Testing R Matrices')
R1_X = GenerateRMatrix(sub_1_test_final, N);
disp('2/3')
R2_X = GenerateRMatrix(sub_2_test_final, N);
disp('3/3')
R3_X = GenerateRMatrix(sub_3_test_final, N);

X1 = R1_X(1 + N : end - N, :); 
X2 = R2_X(1 + N : end - N, :); 
X3 = R3_X(1 + N : end - N, :); 

%%Initialize Y1_hat, Y2_hat, and Y3_hat first
Y1_hat = zeros(size(X1, 1), size(Y1, 2));
Y2_hat = zeros(size(X2, 1), size(Y2, 2));
Y3_hat = zeros(size(X3, 1), size(Y3, 2));

%Calculate Y1_hat, Y2_hat, Y3_hat; required modification to code as betas
%changed to cell arrays
% Y1_hat = X1 * beta1;
% Y2_hat = X2 * beta2;
% Y3_hat = X3 * beta3;

%%If I am not wrong, the first column is the one with highest coefficient

for finger = 1:1:size(Y1, 2)
    fitinfo = fitinfo1{finger};
    Y1_hat(:, finger) = X1 * beta1(:, best_index(1, finger), finger) + fitinfo.Intercept(1);
end

for finger = 1:1:size(Y2, 2)
    fitinfo = fitinfo2{finger};
    Y2_hat(:, finger) = X2 * beta2(:, best_index(2, finger), finger) + fitinfo.Intercept(1);
end

for finger = 1:1:size(Y3, 2)
    fitinfo = fitinfo3{finger};
    Y3_hat(:, finger) = X3 * beta3(:, best_index(3, finger), finger) + fitinfo.Intercept(1);
end


%
Y1_Final = [repmat(Y1_hat(1, :),N,1); Y1_hat; repmat(Y1_hat(end, :),N,1)];
Y2_Final = [repmat(Y2_hat(1, :),N,1); Y2_hat; repmat(Y2_hat(end, :),N,1)];
Y3_Final = [repmat(Y3_hat(1, :),N,1); Y3_hat; repmat(Y3_hat(end, :),N,1)];

L1 = size(Test_ECoG_1, 1);
L2 = size(Test_ECoG_2, 1);
L3 = size(Test_ECoG_3, 1);

% disp('Output Spline')
% YY1 = spline(0 : 50 : L1 - 1, Y1_Final', (0 : L1 - 1))';
% YY2 = spline(0 : 50 : L2 - 1, Y2_Final', (0 : L2 - 1))';
% YY3 = spline(0 : 50 : L3 - 1, Y3_Final', (0 : L3 - 1))';

% disp('Output PCHIP')
% YY1 = pchip(0 : 50 : L1 - 1, Y1_Final', (0 : L1 - 1))';
% YY2 = pchip(0 : 50 : L2 - 1, Y2_Final', (0 : L2 - 1))';
% YY3 = pchip(0 : 50 : L3 - 1, Y3_Final', (0 : L3 - 1))';

disp('Output PCHIP Stage 1/2')
YY1a = pchip(0 : 50 : L1 - 1, Y1_Final', (0 : 10 : L1 - 1))';
YY2a = pchip(0 : 50 : L2 - 1, Y2_Final', (0 : 10 : L2 - 1))';
YY3a = pchip(0 : 50 : L3 - 1, Y3_Final', (0 : 10 : L3 - 1))';

disp('Output PCHIP Stage 2/2')
YY1 = pchip(0 : 10 : L1 - 1, YY1a', (0 : L1 - 1))';
YY2 = pchip(0 : 10 : L2 - 1, YY2a', (0 : L2 - 1))';
YY3 = pchip(0 : 10 : L3 - 1, YY3a', (0 : L3 - 1))';

%smooth_and_maybe_round

YY1_raw = YY1;
YY2_raw = YY2;
YY3_raw = YY3;

YY1_smooth = zeros(size(YY1));
YY2_smooth = zeros(size(YY2));
YY3_smooth = zeros(size(YY3));

for finger = 1:1:size(Y1, 2)    %assuming all three subjects have 5 fingers!!
    YY1_smooth(:, finger) = smooth(YY1(:, finger));
    YY2_smooth(:, finger) = smooth(YY2(:, finger));
    YY3_smooth(:, finger) = smooth(YY3(:, finger));
end

YY1_smooth_round = zeros(size(YY1));
YY2_smooth_round = zeros(size(YY2));
YY3_smooth_round = zeros(size(YY3));

for finger = 1:1:size(Y1, 2)    %assuming all three subjects have 5 fingers!!
    YY1_smooth_round(:, finger) = smooth(round(YY1(:, finger)));
    YY2_smooth_round(:, finger) = smooth(round(YY2(:, finger)));
    YY3_smooth_round(:, finger) = smooth(round(YY3(:, finger)));
end

predicted_dg{1} = YY1_raw;
predicted_dg{2} = YY2_raw;
predicted_dg{3} = YY3_raw;

disp('Saving axon_fired.mat')
save('axon_fired_default_lasso.mat', 'predicted_dg');

predicted_dg{1} = YY1_smooth;
predicted_dg{2} = YY2_smooth;
predicted_dg{3} = YY3_smooth;

disp('Saving axon_fired.mat')
save('axon_fired_default_lasso_smoothed.mat', 'predicted_dg');

predicted_dg{1} = YY1_smooth_round;
predicted_dg{2} = YY2_smooth_round;
predicted_dg{3} = YY3_smooth_round;

disp('Saving axon_fired.mat')
save('axon_fired_default_lasso_smoothed_rounded.mat', 'predicted_dg');


disp('Done.')
disp(' ')
disp(' ')
