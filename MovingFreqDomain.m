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

for chan = 1 : max_chan

  outputA(1, chan) = 0;
  outputB(1, chan) = 0;
  outputC(1, chan) = 0;
  outputD(1, chan) = 0;
  outputE(1, chan) = 0;

  % spectrogram(sub_1_train_part(:,chan), win_size, overlap, Fs, F);
  [S, F_, T_, P, Fc, Tc] = spectrogram(input(:,chan), win_size, overlap, Fs, F);

  absS = abs(S);

  for i = 2 : fn_len
      % Constant also used to make frequency bands similar magnitude
    freq_5_to_15    =  mean(S( 2: 4, i - 1));
    freq_20_to_25   =  mean(S( 5: 6, i - 1));
    freq_75_to_115  =  mean(S(16:24, i - 1));
    freq_125_to_160 =  mean(S(26:33, i - 1));
    freq_160_to_175 =  mean(S(33:36, i - 1));

    outputA(i, chan) = freq_5_to_15;
    outputB(i, chan) = freq_20_to_25;
    outputC(i, chan) = freq_75_to_115;
    outputD(i, chan) = freq_125_to_160;
    outputE(i, chan) = freq_160_to_175;
  end
end

output = [outputA outputB outputC outputD outputE];
end
