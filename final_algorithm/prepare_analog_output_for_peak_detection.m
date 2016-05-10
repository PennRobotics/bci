%% RUN CALCULATIONS ON ANALOG OUTPUT
disp('Clearing workspace to begin peak detection')

% Variables
clear all
do_findpeaks = 0;
manual_peak_shift = 0;

%% IMPORT ANALOG GLOVE PREDICTIONS
load final_axon_fired_analog

y1 = predicted_dg{1};
y2 = predicted_dg{2};
y3 = predicted_dg{3};

%% NORMALIZE GLOVE PREDICTIONS
% TODO(brwr): Length assumed equal for all subjects
L = size(y1, 1);

mean1 = ones(L, 1) * mean(y1); % Create matrix with equal columns (mean)
mean2 = ones(L, 1) * mean(y2);
mean3 = ones(L, 1) * mean(y3);

sd1   = ones(L, 1) *  std(y1); % (standard deviation)
sd2   = ones(L, 1) *  std(y2);
sd3   = ones(L, 1) *  std(y3);

% TODO(brwr): This should heavily favor more reliable data (modified norm!)
y1_norm = (y1 - mean1) ./ sd1; % Change sd1 to 1 to remove norm
y2_norm = (y2 - mean2) ./ sd2;
y3_norm = (y3 - mean3) ./ sd3;

y1_all = sum(y1_norm, 2); % sum of all finger data as a single transient vector
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

if do_findpeaks 
  disp('Peaks detected using findpeaks() algorithm')
  [peaks1, loc1] = findpeaks(analog1, 'MinPeakProminence', 2);  % Find distinct peaks
  [peaks2, loc2] = findpeaks(analog2, 'MinPeakProminence', 2);
  [peaks3, loc3] = findpeaks(analog3, 'MinPeakProminence', 2);

  if manual_peak_shift
    %% MANUAL OVERRIDE OF DETECTED PEAKS
    loc1( 9) = loc1( 9) + 1000;
    loc1(16) = loc1(16) +  500;
    loc1(21) = loc1(21) +  500;
    loc1(24) = loc1(24) +  500;
    loc1(25) = loc1(25) -  250;
    loc1(30) = loc1(30) +  500;
    loc1(32) = loc1(32) +  500;
    loc2( 5) = loc2( 5) :  500;
    loc2     = [   loc2(1:26); 105450;   loc2(27:end)];
    peaks2   = [ peaks2(1:26);      3; peaks2(27:end)];
    loc3(16) = loc3(16) - 1000;
    loc3(17) = loc3(17) +  500;
  else
    disp('Peak positions were NOT manually overridden')
  end
else
  disp('Peaks generated instead of detected')

  %% CREATE SAMPLING BINS
  avg_dist1 = 4000; % 3999; % avg_dist1 = mean(diff(loc1));
  avg_dist2 = 4000; % 4020; % avg_dist2 = mean(diff(loc2));
  avg_dist3 = 4000; % 4041; % avg_dist3 = mean(diff(loc3));

  offset1   = 1500; % 1286; % offset1   = mean(mod(loc1, avg_dist1));
  offset2   = 1400; %  861; % offset2   = mean(mod(loc2, avg_dist2));
  offset3   = 1100; % 1722; % offset3   = mean(mod(loc3, avg_dist3));

  loc1 = round(offset1 : avg_dist1 : length(y1_all)); % Index of all expected peaks
  loc2 = round(offset2 : avg_dist2 : length(y2_all));
  loc3 = round(offset3 : avg_dist3 : length(y3_all));

  peaks1 = ones(1, 37);
  peaks2 = ones(1, 37);
  peaks3 = ones(1, 37);
end
