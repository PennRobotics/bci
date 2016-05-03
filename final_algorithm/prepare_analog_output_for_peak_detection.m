%% IMPORT GLOVE PREDICTIONS

clear all
load final_axon_fired

y1 = predicted_dg{1};
y2 = predicted_dg{2};
y3 = predicted_dg{3};

%% QUASI-NORMALIZE GLOVE PREDICTIONS
L = size(y1, 1);

mean1 = ones(L, 1) * mean(y1);
mean2 = ones(L, 1) * mean(y2);
mean3 = ones(L, 1) * mean(y3);

sd1   = ones(L, 1) *  std(y1);
sd2   = ones(L, 1) *  std(y2);
sd3   = ones(L, 1) *  std(y3);

y1_norm = (y1 - mean1) .* (1 + sd1) ./ (2 * sd1);
y2_norm = (y2 - mean2) .* (1 + sd2) ./ (2 * sd2);
y3_norm = (y3 - mean3) .* (1 + sd3) ./ (2 * sd3);

y1_all = sum(y1_norm, 2);
y2_all = sum(y2_norm, 2);
y3_all = sum(y3_norm, 2);


%% DETECT PEAKS IN NEURAL ACTIVITY
pk1 = y1_all;
pk2 = y2_all;
pk3 = y3_all;

pk1 = max(pk1, 0);  % Create floor of step function (linked to neural activity)
pk2 = max(pk2, 0);
pk3 = max(pk3, 0);

pk1(pk1 > 0) = 5;   % Create ceil of step function
pk2(pk2 > 0) = 5;
pk3(pk3 > 0) = 5;

analog1 = smooth(pk1, 1000); % D2A neural activity (creates peaks)
analog2 = smooth(pk2, 1000);
analog3 = smooth(pk3, 1000);

if 0
  [peaks1, loc1] = findpeaks(analog1, 'MinPeakProminence', 2);  % Find distinct peaks
  [peaks2, loc2] = findpeaks(analog2, 'MinPeakProminence', 2);
  [peaks3, loc3] = findpeaks(analog3, 'MinPeakProminence', 2);

  % MANUAL OVERRIDE OF DETECTED PEAKS
  loc1( 9) = loc1( 9) + 1000;
  loc1(16) = loc1(16) +  500;
  loc1(21) = loc1(21) +  500;
  loc1(24) = loc1(24) +  500;
  loc1(25) = loc1(25) -  250;
  loc1(30) = loc1(30) +  500;
  loc1(32) = loc1(32) +  500;
  loc2( 5) = loc2( 5) :  500;
  loc2     = [  loc2(1:26); 105450;   loc2(27:end)];
  peaks2   = [peaks2(1:26);      3; peaks2(27:end)];
  loc3(16) = loc3(16) - 1000;
  loc3(17) = loc3(17) +  500;
else
  %% CREATE SAMPLING BINS
  avg_dist1 = 4000; % 3999; % avg_dist1 = mean(diff(loc1));
  avg_dist2 = 4000; % 4020; % avg_dist2 = mean(diff(loc2));
  avg_dist3 = 4000; % 4041; % avg_dist3 = mean(diff(loc3));

  offset1   = 1275; % 1286; % offset1   = mean(mod(loc1, avg_dist1));
  offset2   = 1275; %  861; % offset2   = mean(mod(loc2, avg_dist2));
  offset3   = 1275; % 1722; % offset3   = mean(mod(loc3, avg_dist3));

  loc1 = round(offset1 : avg_dist1 : length(y1_all)); % Index of all expected peaks
  loc2 = round(offset2 : avg_dist2 : length(y2_all));
  loc3 = round(offset3 : avg_dist3 : length(y3_all));

  peaks1 = 5 * ones(1, 37);
  peaks2 = 5 * ones(1, 37);
  peaks3 = 5 * ones(1, 37);
end


%% SAMPLE AT EACH SAMPLING BIN
WINDOW_SIZE = 2000;   % Window size [ms]
WINDOW_TYPE = 'tukeywin';
y1_delta = PeakSampleFn(y1_norm, loc1, peaks1, WINDOW_SIZE, WINDOW_TYPE);
y2_delta = PeakSampleFn(y2_norm, loc2, peaks2, WINDOW_SIZE, WINDOW_TYPE);
y3_delta = PeakSampleFn(y3_norm, loc3, peaks3, WINDOW_SIZE, WINDOW_TYPE);


%% MANUAL OVERRIDE OF INDIVIDUAL PEAKS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('SUB1'); y1_delta = PeakSampleManualFn(y1_norm, loc1, WINDOW_SIZE, WINDOW_TYPE);
% disp('SUB2'); y2_delta = PeakSampleManualFn(y2_norm, loc2, WINDOW_SIZE, WINDOW_TYPE);
% disp('SUB3'); y3_delta = PeakSampleManualFn(y3_norm, loc3, WINDOW_SIZE, WINDOW_TYPE);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% CREATE OUTPUT SHAPES FOR EACH FINGER
load subject1
load subject2
load subject3

Train_Glove_1(104000:105999, :) = [];
Train_Glove_2(104000:105999, :) = [];
Train_Glove_3(104000:105999, :) = [];

S1F1 = sum(reshape(Train_Glove_1(:, 1), 4000, 77), 2);
S1F2 = sum(reshape(Train_Glove_1(:, 2), 4000, 77), 2);
S1F3 = sum(reshape(Train_Glove_1(:, 3), 4000, 77), 2);
S1F4 = sum(reshape(Train_Glove_1(:, 4), 4000, 77), 2);
S1F5 = sum(reshape(Train_Glove_1(:, 5), 4000, 77), 2);

S2F1 = sum(reshape(Train_Glove_2(:, 1), 4000, 77), 2);
S2F2 = sum(reshape(Train_Glove_2(:, 2), 4000, 77), 2);
S2F3 = sum(reshape(Train_Glove_2(:, 3), 4000, 77), 2);
S2F4 = sum(reshape(Train_Glove_2(:, 4), 4000, 77), 2);
S2F5 = sum(reshape(Train_Glove_2(:, 5), 4000, 77), 2);

S3F1 = sum(reshape(Train_Glove_3(:, 1), 4000, 77), 2);
S3F2 = sum(reshape(Train_Glove_3(:, 2), 4000, 77), 2);
S3F3 = sum(reshape(Train_Glove_3(:, 3), 4000, 77), 2);
S3F4 = sum(reshape(Train_Glove_3(:, 4), 4000, 77), 2);
S3F5 = sum(reshape(Train_Glove_3(:, 5), 4000, 77), 2);

save('final_shapes.mat','S1F1','S1F2','S1F3','S1F4','S1F5', ...
                        'S2F1','S2F2','S2F3','S2F4','S2F5', ...
                        'S3F1','S3F2','S3F3','S3F4','S3F5')

%% GENERATE OUTPUT SIGNAL USING PEAK SAMPLES
y1_hat = zeros(size(y1_delta));
y2_hat = zeros(size(y2_delta));
y3_hat = zeros(size(y3_delta));

y1_hat(:, 1) = conv(y1_delta(:, 1), S1F1, 'same');
y1_hat(:, 2) = conv(y1_delta(:, 2), S1F2, 'same');
y1_hat(:, 3) = conv(y1_delta(:, 3), S1F3, 'same');
y1_hat(:, 4) = conv(y1_delta(:, 4), S1F4, 'same');
y1_hat(:, 5) = conv(y1_delta(:, 5), S1F5, 'same');
y2_hat(:, 1) = conv(y2_delta(:, 1), S2F1, 'same');
y2_hat(:, 2) = conv(y2_delta(:, 2), S2F2, 'same');
y2_hat(:, 3) = conv(y2_delta(:, 3), S2F3, 'same');
y2_hat(:, 4) = conv(y2_delta(:, 4), S2F4, 'same');
y2_hat(:, 5) = conv(y2_delta(:, 5), S2F5, 'same');
y3_hat(:, 1) = conv(y3_delta(:, 1), S3F1, 'same');
y3_hat(:, 2) = conv(y3_delta(:, 2), S3F2, 'same');
y3_hat(:, 3) = conv(y3_delta(:, 3), S3F3, 'same');
y3_hat(:, 4) = conv(y3_delta(:, 4), S3F4, 'same');
y3_hat(:, 5) = conv(y3_delta(:, 5), S3F5, 'same');

if 0
  figure(1); clf reset
    subplot(2,1,1); findpeaks(analog1,'MinPeakProminence',2); xbound = xlim;
    subplot(2,1,2); plot(y1_hat); xlim(xbound); grid on; legend 1 2 3 4 5
  figure(2); clf reset
    subplot(2,1,1); findpeaks(analog2,'MinPeakProminence',2); xbound = xlim;
    subplot(2,1,2); plot(y2_hat); xlim(xbound); grid on; legend 1 2 3 4 5
  figure(3); clf reset
    subplot(2,1,1); findpeaks(analog3,'MinPeakProminence',2); xbound = xlim;
    subplot(2,1,2); plot(y3_hat); xlim(xbound); grid on; legend 1 2 3 4 5
else
  disp('PLOTS DISABLED!')
end

predicted_dg{1} = y1_hat;
predicted_dg{2} = y2_hat;
predicted_dg{3} = y3_hat;

if 1
  % inputstr = input('Save filename? ', 's');
  inputstr = 'final_output.mat';
  save(inputstr, 'predicted_dg')
  disp(['Saved to ' inputstr])
else
  disp('MATFILE WAS NOT SAVED!')
end
