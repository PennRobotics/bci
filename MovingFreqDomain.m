function [output] = MovingAverage(input)

debug_output = 1; %TODO

win_size = 100; % [ms]
overlap = 50; % [ms]
Fs = 200; % [freq. divisions]
F = 1000; % [Hz]

fn_len = size(input, 1);
max_chan = size(input, 2);

outputA = zeros(max_chan, fn_len);
outputB = zeros(max_chan, fn_len);
outputC = zeros(max_chan, fn_len);
outputD = zeros(max_chan, fn_len);
outputE = zeros(max_chan, fn_len);

% This is used to make frequency bands relatively same-sized
reduce = (linspace(1e-4, 1, 101)' .^ 2) ./ linspace(1500,1,101)';

if debug_output; fprintf('\n'); end

for chan = 1 : max_chan

  if debug_output; fprintf('%i ', chan); end
  % spectrogram(sub_1_train_part(:,chan), win_size, overlap, Fs, F);
  [S, F_, T_, P, Fc, Tc] = spectrogram(input(:,chan), win_size, overlap, Fs, F);

  for i = 1 : fn_len - overlap
    if mod(i, overlap) == 1
      idx = ceil(i / overlap);
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
  for i = fn_len - overlap + 1 : fn_len
    outputA(chan, i) = freq_5_to_15;
    outputB(chan, i) = freq_20_to_25;
    outputC(chan, i) = freq_75_to_115;
    outputD(chan, i) = freq_125_to_160;
    outputE(chan, i) = freq_160_to_175;
  end
end

if debug_output; fprintf('\n'); end

output = [outputA; outputB; outputC; outputD; outputE];
end
