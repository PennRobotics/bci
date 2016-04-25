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
  offset2   = 1075;
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
y1_delta = PeakSample(y1_norm, loc1, peaks1, WINDOW_SIZE, WINDOW_TYPE);
y2_delta = PeakSample(y2_norm, loc2, peaks2, WINDOW_SIZE, WINDOW_TYPE);
y3_delta = PeakSample(y3_norm, loc3, peaks3, WINDOW_SIZE, WINDOW_TYPE);


%% MANUAL OVERRIDE OF INDIVIDUAL PEAKS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO(brwr): Allow default on pressing ENTER
% disp('SUB1'); y1_delta = PeakSampleManual(y1_norm, loc1, WINDOW_SIZE, WINDOW_TYPE);
disp('SUB2'); y2_delta = PeakSampleManual(y2_norm, loc2, WINDOW_SIZE, WINDOW_TYPE);
% disp('SUB3'); y3_delta = PeakSampleManual(y3_norm, loc3, WINDOW_SIZE, WINDOW_TYPE);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
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
