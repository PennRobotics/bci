clear all

Ts = 100; Tw = 200;

disp('Loading Subject Raw Features')
load subject1
load subject2
load subject3

if 0
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

Y1 = sub_1_glove_decimated(1 + N : end - N, :);
Y2 = sub_2_glove_decimated(1 + N : end - N, :);
Y3 = sub_3_glove_decimated(1 + N : end - N, :);

disp('Linear Regression')
beta1 = (R1' * R1) \ R1' * Y1;
beta2 = (R2' * R2) \ R2' * Y2;
beta3 = (R3' * R3) \ R3' * Y3;

disp('1/3  Generating Testing R Matrices')
R1_X = GenerateRMatrix(sub_1_test_final, N);
disp('2/3')
R2_X = GenerateRMatrix(sub_2_test_final, N);
disp('3/3')
R3_X = GenerateRMatrix(sub_3_test_final, N);

X1 = R1_X(1 + N : end - N, :); 
X2 = R2_X(1 + N : end - N, :); 
X3 = R3_X(1 + N : end - N, :); 

Y1_hat = X1 * beta1;
Y2_hat = X2 * beta2;
Y3_hat = X3 * beta3;

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
save('axon_fired.mat', 'predicted_dg');

disp('Done.')
disp(' ')
disp(' ')
