function [output] = MovingFreqDomAdj(input, Tsample, Twindow)

Fs = 200; % [freq. divisions * 2]
F = 1000; % [Hz]

max_chan = size(input, 2);
fn_len = floor((size(input, 1) - Twindow) / Tsample + 1);

overlap = Twindow - Tsample;

outputA = zeros(fn_len, max_chan);
outputB = zeros(fn_len, max_chan);
outputC = zeros(fn_len, max_chan);
outputD = zeros(fn_len, max_chan);
outputE = zeros(fn_len, max_chan);

for chan = 1 : max_chan

  % spectrogram(sub_1_train_part(:,chan), win_size, overlap, Fs, F);
  [S, F_, T_, P, Fc, Tc] = spectrogram(input(:,chan), Twindow, overlap, Fs, F);

  absS = abs(S);

  for i = 1 : fn_len
      % Constant also used to make frequency bands similar magnitude
    freq_5_to_15    =  mean(absS( 2: 4, i));
    freq_20_to_25   =  mean(absS( 5: 6, i));
    freq_75_to_115  =  mean(absS(16:24, i));
    freq_125_to_160 =  mean(absS(26:33, i));
    freq_160_to_175 =  mean(absS(33:36, i));

    outputA(i, chan) = freq_5_to_15;
    outputB(i, chan) = freq_20_to_25;
    outputC(i, chan) = freq_75_to_115;
    outputD(i, chan) = freq_125_to_160;
    outputE(i, chan) = freq_160_to_175;
  end
end

output = [outputA outputB outputC outputD outputE];
end
