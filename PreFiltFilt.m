clear all

load subject1
load subject2
load subject3
n =4; %Order of filter
Rp = 0.1; %Passband ripple
Rs = 40; %Stopband attenuation
Wp = 0.12;   %Normalized passband edge frequency
[b,a]=ellip(n,Rp,Rs,Wp,'low');

%   Subject 1 - Filtering
sub_1_filtered = filtfilt(b,a, Train_ECoG_1);
sub_1_glove = filtfilt(b,a, Train_Glove_1);
sub_1_test = filtfilt(b,a, Test_ECoG_1);

%   Subject 2 - Filtering
sub_2_filtered = filtfilt(b,a, Train_ECoG_2);
sub_2_glove = filtfilt(b,a, Train_Glove_2);
sub_2_test = filtfilt(b,a, Test_ECoG_2);

%   Subject 3 - Filtering
sub_3_filtered = filtfilt(b,a, Train_ECoG_3);
sub_3_glove = filtfilt(b,a, Train_Glove_3);
sub_3_test = filtfilt(b,a, Test_ECoG_3);

% sub_1_train_MA = MovingAverage(Train_ECoG_1); disp('1 Train MA')
sub_1_train_MA = MovingAverage(sub_1_filtered); disp('1 Train MA')
save('subject1a.mat', 'sub_1_train_MA'); % clear s*
sub_1_train_FD = MovingFreqDomain(sub_1_filtered); disp('1 Train FD')
save('subject1b.mat', 'sub_1_train_FD'); %clear s*
sub_1_glove_MA = MovingAverage(sub_1_glove); disp('1 Glove MA')
save('subject1c.mat', 'sub_1_glove_MA'); %clear s*
sub_1_glove_FD = MovingFreqDomain(sub_1_glove); disp('1 Glove FD')
save('subject1d.mat', 'sub_1_glove_FD'); %clear s*
sub_1_test_MA = MovingAverage(sub_1_test); disp('1 Test MA')
save('subject1e.mat', 'sub_1_test_MA'); %clear s*
sub_1_test_FD = MovingFreqDomain(sub_1_test); disp('1 Test FD')
save('subject1f.mat', 'sub_1_test_FD'); %clear s*

sub_2_train_MA = MovingAverage(sub_2_filtered); disp('2 Train MA')
save('subject2a.mat', 'sub_2_train_MA'); %clear s*
sub_2_train_FD = MovingFreqDomain(sub_2_filtered); disp('2 Train FD')
save('subject2b.mat', 'sub_2_train_FD'); %clear s*
sub_2_glove_MA = MovingAverage(sub_2_glove); disp('2 Glove MA')
save('subject2c.mat', 'sub_2_glove_MA'); %clear s*
sub_2_glove_FD = MovingFreqDomain(sub_2_glove); disp('2 Glove FD')
save('subject2d.mat', 'sub_2_glove_FD'); %clear s*
sub_2_test_MA = MovingAverage(sub_2_test); disp('2 Test MA')
save('subject2e.mat', 'sub_2_test_MA'); %clear s*
sub_2_test_FD = MovingFreqDomain(sub_2_test); disp('2 Test FD')
save('subject2f.mat', 'sub_2_test_FD'); %clear s*

sub_3_train_MA = MovingAverage(sub_3_filtered); disp('3 Train MA')
save('subject3a.mat', 'sub_3_train_MA'); %clear s*
sub_3_train_FD = MovingFreqDomain(sub_3_filtered); disp('3 Train FD')
save('subject3b.mat', 'sub_3_train_FD'); %clear s*
sub_3_glove_MA = MovingAverage(sub_3_glove); disp('3 Glove MA')
save('subject3c.mat', 'sub_3_glove_MA'); %clear s*
sub_3_glove_FD = MovingFreqDomain(sub_3_glove); disp('3 Glove FD')
save('subject3d.mat', 'sub_3_glove_FD'); %clear s*
sub_3_test_MA = MovingAverage(sub_3_test); disp('3 Test MA')
save('subject3e.mat', 'sub_3_test_MA'); %clear s*
sub_3_test_FD = MovingFreqDomain(sub_3_test); disp('3 Test FD')
save('subject3f.mat', 'sub_3_test_FD'); %clear s*


%**************************************************************************

%   SUBJECT 1

% COMBINE THE FEATURES OF TRAINING SET
sub_1_train_final = [sub_1_train_MA , sub_1_train_FD];
sub_1_glove_final = [sub_1_glove_MA , sub_1_glove_FD];

% DOWNSAMPLE THE GLOVE DATA
for j = 1:5
     sub1_glove_decimated(:, j) = decimate(sub_1_glove(:, j), 50);
end

% CREATE R MATRIX WITH TRAINING FEATURE MATRIX
sub_1_v = 372;
sub_1_N = 3;
sub_1_M = 310000/50;
sub_1_R1 = zeros(6200, 1+(sub_1_N*sub_1_v)) ;
for sub_1_row = 1:1:(sub_1_M-sub_1_N)+1;
    sub_1_row_to_add = [1];
    for j = 1:1:sub_1_v
        for i = 1:1:sub_1_N
            sub_1_row_to_add = [sub_1_row_to_add, sub_1_train_final(i+sub_1_row-1, j)];
        end
    end
    sub_1_R1(sub_1_row, :) = sub_1_row_to_add;
end

% REMOVE THE FIRST AND LAST 3 ROWS FROM THE R MATRIX
sub_1_R = sub_1_R1(4:end-3, :);

% PERFORM LINEAR REGRESSION
sub_1_Y = sub1_glove_decimated(4:end-3, :);
% B = pinv(R' * R) * R'*Y;
sub_1_B = (sub_1_R' * sub_1_R) \ sub_1_R' * sub_1_Y;

% COMBINE FEATURES OF TEST SET
sub_1_test_final = [sub_1_test_MA , sub_1_test_FD];

% CREATE R MATRIX WITH TEST FEATURE MATRIX
sub_1_v2 = 372;
sub_1_N2 = 3;
sub_1_M2 = 147500/50;
sub_1_R_x_Test = zeros(2950, 1+(sub_1_N2*sub_1_v2)) ;
for sub_1_row = 1:1:(sub_1_M2-sub_1_N2)+1;
    sub_1_row_to_add2 = [1];
    for j = 1:1:sub_1_v2
        for i = 1:1:sub_1_N2
            sub_1_row_to_add2 = [sub_1_row_to_add2, sub_1_test_final(i+sub_1_row-1, j)];
        end
    end
    sub_1_R_x_Test(sub_1_row, :) = sub_1_row_to_add2;
end

% REMOVE THE FIRST AND LAST 3 ROWS FROM THE R MATRIX
sub_1_Xnew = sub_1_R_x_Test(4:end-3, :); 

% Yhat = XB
sub_1_Ycap = sub_1_Xnew * sub_1_B;
sub_1_Y_Final = [repmat(sub_1_Ycap(1,:),3,1); sub_1_Ycap; repmat(sub_1_Ycap(end,:),3,1)];
sub_1_L =length(Test_ECoG_1(:,1));

% SPLINE INTERPOLATION 
sub_1_YY = spline(0:50:sub_1_L-1, sub_1_Y_Final', (0:sub_1_L-1));
sub_1_YY = sub_1_YY';

% *****************************************************************************************

%   SUBJECT 2

% COMBINE THE FEATURES OF TRAINING SET
sub_2_train_final = [sub_2_train_MA , sub_2_train_FD];
sub_2_glove_final = [sub_2_glove_MA , sub_2_glove_FD];

% DOWNSAMPLE THE GLOVE DATA
for j = 1:5
     sub2_glove_decimated(:, j) = decimate(sub_2_glove(:, j), 50);
end

% CREATE R MATRIX WITH TRAINING FEATURE MATRIX
sub_2_v = 288;
sub_2_N = 3;
sub_2_M = 310000/50;
sub_2_R1 = zeros(6200, 1+(sub_2_N*sub_2_v)) ;
for sub_2_row = 1:1:(sub_2_M-sub_2_N)+1;
    sub_2_row_to_add = [1];
    for j = 1:1:sub_2_v
        for i = 1:1:sub_2_N
            sub_2_row_to_add = [sub_2_row_to_add, sub_2_train_final(i+sub_2_row-1, j)];
        end
    end
    sub_2_R1(sub_2_row, :) = sub_2_row_to_add;
end

% REMOVE THE FIRST AND LAST 3 ROWS FROM THE R MATRIX
sub_2_R = sub_2_R1(4:end-3, :);

% PERFORM LINEAR REGRESSION
sub_2_Y = sub2_glove_decimated(4:end-3, :);
% B = pinv(R' * R) * R'*Y;
sub_2_B = (sub_2_R' * sub_2_R) \ sub_2_R' * sub_2_Y;

% COMBINE FEATURES OF TEST SET
sub_2_test_final = [sub_2_test_MA , sub_2_test_FD];

% CREATE R MATRIX WITH TEST FEATURE MATRIX
sub_2_v2 = 288;
sub_2_N2 = 3;
sub_2_M2 = 147500/50;
sub_2_R_x_Test = zeros(2950, 1+(sub_2_N2*sub_2_v2)) ;
for sub_2_row = 1:1:(sub_2_M2-sub_2_N2)+1;
    sub_2_row_to_add2 = [1];
    for j = 1:1:sub_2_v2
        for i = 1:1:sub_2_N2
            sub_2_row_to_add2 = [sub_2_row_to_add2, sub_2_test_final(i+sub_2_row-1, j)];
        end
    end
    sub_2_R_x_Test(sub_2_row, :) = sub_2_row_to_add2;
end

% REMOVE THE FIRST AND LAST 3 ROWS FROM THE R MATRIX
sub_2_Xnew = sub_2_R_x_Test(4:end-3, :); 

% Yhat = XB
sub_2_Ycap = sub_2_Xnew * sub_2_B;
sub_2_Y_Final = [repmat(sub_2_Ycap(1,:),3,1); sub_2_Ycap; repmat(sub_2_Ycap(end,:),3,1)];
sub_2_L =length(Test_ECoG_2(:,1));

% SPLINE INTERPOLATION 
sub_2_YY = spline(0:50:sub_2_L-1, sub_2_Y_Final', (0:sub_2_L-1));
sub_2_YY = sub_2_YY';

% *******************************************************************************************

%   SUBJECT 3

% COMBINE THE FEATURES OF TRAINING SET
sub_3_train_final = [sub_3_train_MA , sub_3_train_FD];
sub_3_glove_final = [sub_3_glove_MA , sub_3_glove_FD];

% DOWNSAMPLE THE GLOVE DATA
for j = 1:5
     sub3_glove_decimated(:, j) = decimate(sub_3_glove(:, j), 50);
end

% CREATE R MATRIX WITH TRAINING FEATURE MATRIX
sub_3_v = 384;
sub_3_N = 3;
sub_3_M = 310000/50;
sub_3_R1 = zeros(6200, 1+(sub_3_N*sub_3_v)) ;
for sub_3_row = 1:1:(sub_3_M-sub_3_N)+1;
    sub_3_row_to_add = [1];
    for j = 1:1:sub_3_v
        for i = 1:1:sub_3_N
            sub_3_row_to_add = [sub_3_row_to_add, sub_3_train_final(i+sub_3_row-1, j)];
        end
    end
    sub_3_R1(sub_3_row, :) = sub_3_row_to_add;
end

% REMOVE THE FIRST AND LAST 3 ROWS FROM THE R MATRIX
sub_3_R = sub_3_R1(4:end-3, :);

% PERFORM LINEAR REGRESSION
sub_3_Y = sub3_glove_decimated(4:end-3, :);
% B = pinv(R' * R) * R'*Y;
sub_3_B = (sub_3_R' * sub_3_R) \ sub_3_R' * sub_3_Y;

% COMBINE FEATURES OF TEST SET
sub_3_test_final = [sub_3_test_MA , sub_3_test_FD];

% CREATE R MATRIX WITH TEST FEATURE MATRIX
sub_3_v2 = 384;
sub_3_N2 = 3;
sub_3_M2 = 147500/50;
sub_3_R_x_Test = zeros(2950, 1+(sub_3_N2*sub_3_v2)) ;
for sub_3_row = 1:1:(sub_3_M2-sub_3_N2)+1;
    sub_3_row_to_add2 = [1];
    for j = 1:1:sub_3_v2
        for i = 1:1:sub_3_N2
            sub_3_row_to_add2 = [sub_3_row_to_add2, sub_3_test_final(i+sub_3_row-1, j)];
        end
    end
    sub_3_R_x_Test(sub_3_row, :) = sub_3_row_to_add2;
end

% REMOVE THE FIRST AND LAST 3 ROWS FROM THE R MATRIX
sub_3_Xnew = sub_3_R_x_Test(4:end-3, :); 

% Yhat = XB
sub_3_Ycap = sub_3_Xnew * sub_3_B;
sub_3_Y_Final = [repmat(sub_3_Ycap(1,:),3,1); sub_3_Ycap; repmat(sub_3_Ycap(end,:),3,1)];
sub_3_L =length(Test_ECoG_3(:,1));

% SPLINE INTERPOLATION 
sub_3_YY = spline(0:50:sub_3_L-1, sub_3_Y_Final', (0:sub_3_L-1));
sub_3_YY = sub_3_YY';

