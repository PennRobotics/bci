%% IMPORT GLOVE PREDICTIONS
clear all
load axon_fired_Smooth

y1 = predicted_dg{1};
y2 = predicted_dg{2};
y3 = predicted_dg{3};

if 0
  load subject1
  y1 = Train_Glove_1;
  clear T*

  load subject2
  y2 = Train_Glove_2;
  clear T*

  load subject3
  y3 = Train_Glove_3;
  clear T*
end

%% NORMALIZE GLOVE PREDICTIONS
L = size(y1, 1);

mean1 = ones(L, 1) * mean(y1);
mean2 = ones(L, 1) * mean(y2);
mean3 = ones(L, 1) * mean(y3);

sd1   = ones(L, 1) *  std(y1);
sd2   = ones(L, 1) *  std(y2);
sd3   = ones(L, 1) *  std(y3);

y1_norm = (y1 - mean1) ./ sd1;
y2_norm = (y2 - mean2) ./ sd2;
y3_norm = (y3 - mean3) ./ sd3;

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

[peaks1, loc1] = findpeaks(analog1, 'MinPeakProminence', 2);  % Find distinct peaks
[peaks2, loc2] = findpeaks(analog2, 'MinPeakProminence', 2);
[peaks3, loc3] = findpeaks(analog3, 'MinPeakProminence', 2);


%% CREATE SAMPLING BINS
avg_dist1 = 4000; % mean(diff(loc1));  % Average distance between peaks
avg_dist2 = 4000; % mean(diff(loc2));
avg_dist3 = 4000; % mean(diff(loc3));

offset1   = 1275; % mean(mod(loc1, avg_dist1));  % Index offset from beginning of time
offset2   = 1275; % mean(mod(loc2, avg_dist2));
offset3   = 1275; % mean(mod(loc3, avg_dist3));

Q1_peak = round(offset1 : avg_dist1 : length(y1_all)); % Index of all expected peaks
Q2_peak = round(offset2 : avg_dist2 : length(y2_all));
Q3_peak = round(offset3 : avg_dist3 : length(y3_all));


%% SAMPLE AT EACH SAMPLING BI
WINDOW_SIZE = 2000;   % Window size [ms]
WINDOW_TYPE = 'tukeywin';
y1_delta = PeakSample(y1_norm, Q1_peak, WINDOW_SIZE, WINDOW_TYPE);
y2_delta = PeakSample(y2_norm, Q2_peak, WINDOW_SIZE, WINDOW_TYPE);
y3_delta = PeakSample(y3_norm, Q3_peak, WINDOW_SIZE, WINDOW_TYPE);

% y1_delta = PeakSampleManual(y1_norm, Q1_peak, WINDOW_SIZE, WINDOW_TYPE);
% y2_delta = PeakSampleManual(y2_norm, Q2_peak, WINDOW_SIZE, WINDOW_TYPE);
% y3_delta = PeakSampleManual(y3_norm, Q3_peak, WINDOW_SIZE, WINDOW_TYPE);

%% GENERATE OUTPUT SIGNAL USING PEAK SAMPLES
y1_hat = zeros(size(y1_delta));
y2_hat = zeros(size(y2_delta));
y3_hat = zeros(size(y3_delta));

OutputShape = tukeywin(5001, 0.75); % Previous 5001, 75

for i = 1:5
  y1_hat(:, i) = conv(y1_delta(:, i), OutputShape, 'same');
  y2_hat(:, i) = conv(y2_delta(:, i), OutputShape, 'same');
  y3_hat(:, i) = conv(y3_delta(:, i), OutputShape, 'same');
end


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

if 0
  inputstr = input('Save filename? ', 's');
  save(inputstr,'predicted_dg')
  disp(['Saved to ' inputstr])
else
  disp('MATFILE WAS NOT SAVED!')
end

% hold on; h = plot(0.3*y1(:,1));
% delete(h)
