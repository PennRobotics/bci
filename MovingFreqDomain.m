function [output] = MovingFreqDomain(input)

win_size = 100; % [ms]
overlap = 50; % [ms]
Fs = 200; % [freq. divisions * 2]
F = 1000; % [Hz]

max_chan = size(input, 2);
fn_len = size(input, 1) / 50;

outputA = zeros(fn_len, max_chan);
outputB = zeros(fn_len, max_chan);
outputC = zeros(fn_len, max_chan);
outputD = zeros(fn_len, max_chan);
outputE = zeros(fn_len, max_chan);

% This is used to make frequency bands relatively same-sized
reduce = (linspace(1e-4, 1, 101)' .^ 2) ./ linspace(1500,1,101)';

for chan = 1 : max_chan

  outputA(1, chan) = 0;
  outputB(1, chan) = 0;
  outputC(1, chan) = 0;
  outputD(1, chan) = 0;
  outputE(1, chan) = 0;

  % spectrogram(sub_1_train_part(:,chan), win_size, overlap, Fs, F);
  [S, F_, T_, P, Fc, Tc] = spectrogram(input(:,chan), win_size, overlap, Fs, F);

  for i = 2 : fn_len
      % Constant also used to make frequency bands similar magnitude
    freq_5_to_15    =  3.0 * mean(P( 2: 4, i - 1) .* reduce( 2: 4));
    freq_20_to_25   =  5.5 * mean(P( 5: 6, i - 1) .* reduce( 5: 6));
    freq_75_to_115  = 20.0 * mean(P(16:24, i - 1) .* reduce(16:24));
    freq_125_to_160 = 29.5 * mean(P(26:33, i - 1) .* reduce(26:33));
    freq_160_to_175 = 34.5 * mean(P(33:36, i - 1) .* reduce(33:36));

    outputA(i, chan) = freq_5_to_15;
    outputB(i, chan) = freq_20_to_25;
    outputC(i, chan) = freq_75_to_115;
    outputD(i, chan) = freq_125_to_160;
    outputE(i, chan) = freq_160_to_175;
  end
end

output = [outputA outputB outputC outputD outputE];
end
