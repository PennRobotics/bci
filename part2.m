clear all

load subject1
load subject2
load subject3

part_length = 50000;

% TODO(brwr): Expand this to all data and channels
sub_1_train_part = Train_ECoG_1(1:part_length, 16:31);
sub_2_train_part = Train_ECoG_2(1:part_length, 16:31);
sub_3_train_part = Train_ECoG_3(1:part_length, 16:31);

sub_1_glove_part = Train_Glove_1(1:part_length, 1:5);
sub_2_glove_part = Train_Glove_2(1:part_length, 1:5);
sub_3_glove_part = Train_Glove_3(1:part_length, 1:5);

sub_1_test_part = Test_ECoG_1(1:part_length, 16:31);
sub_2_test_part = Test_ECoG_2(1:part_length, 16:31);
sub_3_test_part = Test_ECoG_3(1:part_length, 16:31);

clear T*

sub_1_train_part_MA = MovingAverage(sub_1_train_part);
sub_2_train_part_MA = MovingAverage(sub_2_train_part);
sub_3_train_part_MA = MovingAverage(sub_3_train_part);

sub_1_glove_part_MA = MovingAverage(sub_1_glove_part);
sub_2_glove_part_MA = MovingAverage(sub_2_glove_part);
sub_3_glove_part_MA = MovingAverage(sub_3_glove_part);

sub_1_test_part_MA = MovingAverage(sub_1_test_part);
sub_2_test_part_MA = MovingAverage(sub_2_test_part);
sub_3_test_part_MA = MovingAverage(sub_3_test_part);

% TODO(brwr): Everything after this should be put in a function
win_size = 100; % [ms]
overlap = 50; % [ms]
Fs = 200; % [freq. divisions]
F = 1000; % [Hz]

% TODO(brwr): Get max channels from input dimensions
max_chan = 16;

% TODO(brwr): Get output matrix sizes from input dimensions
outputA = zeros(max_chan, part_length);
outputB = zeros(max_chan, part_length);
outputC = zeros(max_chan, part_length);
outputD = zeros(max_chan, part_length);
outputE = zeros(max_chan, part_length);

% This is used to make frequency bands relatively same-sized
reduce = (linspace(1e-4, 1, 101)' .^ 2) ./ linspace(1500,1,101)';

for chan = 1 : max_chan

  % TODO(brwr): Remove the plot-generating spectrogram()
  % TODO(brwr): Change "sub_1_train_part" to "input" (reference)
  spectrogram(sub_1_train_part(:,chan), win_size, overlap, Fs, F);
  [S, F_, T_, P, Fc, Tc] = spectrogram(sub_1_train_part(:,chan), win_size, overlap, Fs, F);

  % TODO(brwr): Hard-coded vector/bin sizes!
  for i = 1 : (50000 - 50)
    if mod(i, 50) == 1
      idx = ceil(i / 50);
      % Constant also used to make frequency bands similar magnitude
      freq_5_to_15    =  3.0 * mean(P( 2: 4, idx) .* reduce( 2: 4));
      freq_20_to_25   =  5.5 * mean(P( 5: 6, idx) .* reduce( 5: 6));
      freq_75_to_115  = 20.0 * mean(P(16:24, idx) .* reduce(16:24));
      freq_125_to_160 = 29.5 * mean(P(26:33, idx) .* reduce(26:33));
      freq_160_to_175 = 34.5 * mean(P(33:36, idx) .* reduce(33:36));
    end
    outputA(chan, i) = freq_5_to_15;
    outputB(chan, i) = freq_20_to_25;
    outputC(chan, i) = freq_75_to_115;
    outputD(chan, i) = freq_125_to_160;
    outputE(chan, i) = freq_160_to_175;
  end
  for i = (50000 - 49) : 50000
    outputA(chan, i) = freq_5_to_15;
    outputB(chan, i) = freq_20_to_25;
    outputC(chan, i) = freq_75_to_115;
    outputD(chan, i) = freq_125_to_160;
    outputE(chan, i) = freq_160_to_175;
  end

end
output = [outputA; outputB; outputC; outputD; outputE];
