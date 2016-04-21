function [output] = MovingAverageAdj(input, Tsample, Twindow)

% TODO(brwr): Remove these after function validation
Tsample = 50;
Twindow = 100;

% TODO(brwr): Remove hard-coded 50 and 100
max_chan = size(input, 2);
fn_len = size(input, 1) / Tsample;

output = zeros(fn_len, max_chan);

for chan = 1 : max_chan
  output(1, chan) = 0;
  for i = 2 : fn_len
    % TODO(brwr): This whole algorithm is a hack
    idxStart = Tsample * (i - 2) + 1;
    current_value = mean(input(idxStart : idxStart + Twindow - 1, chan));
    output(i, chan) = current_value;
  end
end

end
