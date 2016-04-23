clear all

Ts = 50; Tw = 250;

disp('Loading Subject Raw Features')
load subject1

Train_ECoG_1_All = Train_ECoG_1;
Train_ECoG_1 = [Train_ECoG_1_All(:, 1:54), Train_ECoG_1_All(:,56:62)];
Test_ECoG_1_All = Test_ECoG_1;
Test_ECoG_1 = [Test_ECoG_1_All(:, 1:54), Test_ECoG_1_All(:,56:62)];

% clear Train_*
load subject2
% clear Train_*
load subject3
% clear Train_*

if 1
  disp('Generating New Features')
  sub_1_train_MA = MovingAverageAdj(Train_ECoG_1, Ts, Tw); disp('1 Train MA')
  sub_1_train_FD = MovingFreqDomAdj(Train_ECoG_1, Ts, Tw); disp('1 Train FD')
  sub_1_test_MA  = MovingAverageAdj( Test_ECoG_1, Ts, Tw); disp('1 Test MA')
  sub_1_test_FD  = MovingFreqDomAdj( Test_ECoG_1, Ts, Tw); disp('1 Test FD')
  save('y_subject1a.mat', 'sub_1_train_MA');
  save('y_subject1b.mat', 'sub_1_train_FD');
  save('y_subject1e.mat', 'sub_1_test_MA');
  save('y_subject1f.mat', 'sub_1_test_FD');
  clear s*

  sub_2_train_MA = MovingAverageAdj(Train_ECoG_2, Ts, Tw); disp('2 Train MA')
  sub_2_train_FD = MovingFreqDomAdj(Train_ECoG_2, Ts, Tw); disp('2 Train FD')
  sub_2_test_MA  = MovingAverageAdj( Test_ECoG_2, Ts, Tw); disp('2 Test MA')
  sub_2_test_FD  = MovingFreqDomAdj( Test_ECoG_2, Ts, Tw); disp('2 Test FD')
  save('y_subject2a.mat', 'sub_2_train_MA');
  save('y_subject2b.mat', 'sub_2_train_FD');
  save('y_subject2e.mat', 'sub_2_test_MA');
  save('y_subject2f.mat', 'sub_2_test_FD');
  clear s*

  sub_3_train_MA = MovingAverageAdj(Train_ECoG_3, Ts, Tw); disp('3 Train MA')
  sub_3_train_FD = MovingFreqDomAdj(Train_ECoG_3, Ts, Tw); disp('3 Train FD')
  sub_3_test_MA  = MovingAverageAdj( Test_ECoG_3, Ts, Tw); disp('3 Test MA')
  sub_3_test_FD  = MovingFreqDomAdj( Test_ECoG_3, Ts, Tw); disp('3 Test FD')
  save('y_subject3a.mat', 'sub_3_train_MA');
  save('y_subject3b.mat', 'sub_3_train_FD');
  save('y_subject3e.mat', 'sub_3_test_MA');
  save('y_subject3f.mat', 'sub_3_test_FD');
  clear s*

  sub_1_glove_decimated = MovingAverageAdj(Train_Glove_1, Ts, Tw);
  sub_2_glove_decimated = MovingAverageAdj(Train_Glove_2, Ts, Tw);
  sub_3_glove_decimated = MovingAverageAdj(Train_Glove_3, Ts, Tw);

  % for j = 1:5
  %   sub_1_glove_decimated(:, j) = decimate(Train_Glove_1(:, j), Ts);
  %   sub_2_glove_decimated(:, j) = decimate(Train_Glove_2(:, j), Ts);
  %   sub_3_glove_decimated(:, j) = decimate(Train_Glove_3(:, j), Ts);
  % end

  save('y_subject1c.mat', 'sub_1_glove_decimated');
  save('y_subject2c.mat', 'sub_2_glove_decimated');
  save('y_subject3c.mat', 'sub_3_glove_decimated');
end

disp('Loading Subject Features')
load y_subject1a; load y_subject1b; load y_subject1c; load y_subject1e; load y_subject1f;
load y_subject2a; load y_subject2b; load y_subject2c; load y_subject2e; load y_subject2f;
load y_subject3a; load y_subject3b; load y_subject3c; load y_subject3e; load y_subject3f;

sub_1_train_final = [sub_1_train_MA , sub_1_train_FD];
sub_1_test_final = [sub_1_test_MA , sub_1_test_FD];

sub_2_train_final = [sub_2_train_MA , sub_2_train_FD];
sub_2_test_final = [sub_2_test_MA , sub_2_test_FD];

sub_3_train_final = [sub_3_train_MA , sub_3_train_FD];
sub_3_test_final = [sub_3_test_MA , sub_3_test_FD];

N = 3; % Number of delays

% sub_1_train_final(:, 55) = [];
% sub_1_test_final(:, 55) = [];

disp('1/3  Generating Training R Matrices')
R1_full = GenerateRMatrix(sub_1_train_final, N);
disp('2/3')
R2_full = GenerateRMatrix(sub_2_train_final, N);
disp('3/3')
R3_full = GenerateRMatrix(sub_3_train_final, N);

% R1 = R1_full( N : end , :);
% R2 = R2_full(N : end , :);
% R3 = R3_full( N : end, :);
R1 = R1_full;
R2 = R2_full;
R3 = R3_full;

Y1 = sub_1_glove_decimated(N : end , :);
Y2 = sub_2_glove_decimated(N : end, :);
Y3 = sub_3_glove_decimated(N : end, :);

% disp('Linear Regression')
% beta1 = (R1' * R1) \ (R1' * Y1);
% beta2 = (R2' * R2) \ (R2' * Y2);
% beta3 = (R3' * R3) \ (R3' * Y3);

alpha = 0.5;
lasso_alpha_value = '0_5';

disp('LASSO Alpha_Setting_modified_for_lasso')
for finger = 1:1:size(Y1, 2)
    [beta, fitinfo] = lasso(R1, Y1(:, finger), 'Alpha', alpha);
    beta1(:, :, finger) = beta;
    fitinfo1{finger} = fitinfo;
    sprintf('\nFinished %d-th finger, subject1', finger)
end

for finger = 1:1:size(Y2, 2)
    [beta, fitinfo] = lasso(R2, Y2(:, finger), 'Alpha', alpha);
    beta2(:, :, finger) = beta;
    fitinfo2{finger} = fitinfo;
    sprintf('\nFinished %d-th finger, subject2', finger)
end

for finger = 1:1:size(Y3, 2)
    [beta, fitinfo] = lasso(R3, Y3(:, finger), 'Alpha', alpha);
    beta3(:, :, finger) = beta;
    fitinfo3{finger} = fitinfo;
    sprintf('\nFinished %d-th finger, subject3', finger)
end

disp('1/3  Generating Testing R Matrices')
R1_X = GenerateRMatrix(sub_1_test_final, N);
disp('2/3')
R2_X = GenerateRMatrix(sub_2_test_final, N);
disp('3/3')
R3_X = GenerateRMatrix(sub_3_test_final, N);

X1 = R1_X; 
X2 = R2_X; 
X3 = R3_X; 

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

beta1_old = beta1;
beta2_old = beta2;
beta3_old = beta3;


%% Create 2D Beta Matrices
load beta_fitinfo_Part2d_Lasso_Default
beta1_old = beta1;
beta2_old = beta2;
beta3_old = beta3;

beta1 = zeros(size(beta1_old, 1), size(beta1_old, 3));
beta2 = zeros(size(beta2_old, 1), size(beta2_old, 3));
beta3 = zeros(size(beta3_old, 1), size(beta3_old, 3));

for finger = 1:1:size(beta1_old, 3)
    for time = 1:1:size(beta1, 1)
        beta1(time, finger) = beta1_old(time, best_index(1, finger), finger);
        sprintf('\nassigned %d to beta1(%d, %d)', beta1_old(time, best_index(1, finger), finger), time, finger)
    end
end

for finger = 1:1:size(beta2_old, 3)
    for time = 1:1:size(beta2, 1)
        beta2(time, finger) = beta2_old(time, best_index(2, finger), finger);
        sprintf('\nassigned %d to beta2(%d, %d)', beta2_old(time, best_index(2, finger), finger), time, finger)
    end
end

for finger = 1:1:size(beta3_old, 3)
    for time = 1:1:size(beta3, 1)
        beta3(time, finger) = beta3_old(time, best_index(3, finger), finger);
        sprintf('\nassigned %d to beta3(%d, %d)', beta3_old(time, best_index(3, finger), finger), time, finger)
    end
end
%% Y_hat predictions with beta
% Need to turn beta into : by 5 matrix
for finger = 1:1:size(beta1_old, 3)
    Y1_hat(:, finger) = X1 * beta1(:, finger);
    Y2_hat(:, finger) = X2 * beta2(:, finger);
    Y3_hat(:, finger) = X3 * beta3(:, finger);
    sprintf('\npredicted raw Y_hat data for finger %d', finger)
end

%% Smooth
for finger = 1:1:size(beta1_old, 3)
    Y1_hat(:, finger) = smooth(Y1_hat(:, finger), 101);
    Y2_hat(:, finger) = smooth(Y2_hat(:, finger), 101);
    Y3_hat(:, finger) = smooth(Y3_hat(:, finger), 101);
end


%% padding
% TODO(brwr): Try stretching instead of padding
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

% TODO(brwr): Shift data around to fit the original data best
% - Pad beginning
% - Pad end
% - Pad ends
% - Change resample freq (stretch)
disp('Output PCHIP')
%YY1 = pchip(Tw - Ts : Ts : L1 - 1, Y1_Final', (0 : L1 - 1))';
%YY2 = pchip(Tw - Ts : Ts : L2 - 1, Y2_Final', (0 : L2 - 1))';
%YY3 = pchip(Tw - Ts : Ts : L3 - 1, Y3_Final', (0 : L3 - 1))';

% TODO(brwr): Try this
 YY1 = pchip(linspace(0, L1, size(Y1_Final, 1)), Y1_Final', linspace(0, L1, L1))';
 YY2 = pchip(linspace(0, L2, size(Y2_Final, 1)), Y2_Final', linspace(0, L2, L2))';
 YY3 = pchip(linspace(0, L3, size(Y3_Final, 1)), Y3_Final', linspace(0, L3, L3))';

% disp('Output PCHIP Stage 1/2')
% YY1a = pchip(0 : Ts : L1 - 1, Y1_Final', (0 : 10 : L1 - 1))';
% YY2a = pchip(0 : Ts : L2 - 1, Y2_Final', (0 : 10 : L2 - 1))';
% YY3a = pchip(0 : Ts : L3 - 1, Y3_Final', (0 : 10 : L3 - 1))';
% 
% disp('Output PCHIP Stage 2/2')
% YY1 = pchip(0 : 10 : L1 - 1, YY1a', (0 : L1 - 1))';
% YY2 = pchip(0 : 10 : L2 - 1, YY2a', (0 : L2 - 1))';
% YY3 = pchip(0 : 10 : L3 - 1, YY3a', (0 : L3 - 1))';

predicted_dg{1} = YY1;
predicted_dg{2} = YY2;
predicted_dg{3} = YY3;

disp('Saving axon_fired.mat')
savenamestring = sprintf('axon_fired_correctedR_No55_Lasso_Alpha_%s.mat', num2str(lasso_alpha_value));
save(savenamestring, 'predicted_dg');

disp('Done.')
disp(' ')
disp(' ')
