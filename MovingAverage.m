function [output] = MovingAverage(input)
% TODO(brwr): Function averages "back in time"

current_value = NaN;
fn_len = size(input, 1);

output = zeros(size(input));

for chan = 1 : size(input, 2)
  for i = 1 : fn_len - 99
    if mod(i, 50) == 1
      current_value = mean(input(i : i + 99, chan));
    end
    output(i, chan) = current_value;
  end
  for i = fn_len - 98 : fn_len 
    output(i, chan) = current_value;
  end
end

end
