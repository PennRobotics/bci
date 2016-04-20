function [output] = MovingAverage(input)

% TODO(brwr): Remove hard-coded 50 and 100
max_chan = size(input, 2);
fn_len = size(input, 1) / 50;

output = zeros(fn_len, max_chan);

for chan = 1 : max_chan
  output(1, chan) = 0;
  for i = 2 : fn_len
    current_value = mean(input(50*(i-2) + 1 : 50 * (i-2) + 100, chan));
    output(i, chan) = current_value;
  end
end

end
