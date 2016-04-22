function [output] = MovingAverageAdj(input, Tsample, Twindow)

max_chan = size(input, 2);
fn_len = floor((size(input, 1) - Twindow) / Tsample + 1);

fn_idx = 1 : Tsample : size(input, 1);
fn_idx_gap = Twindow - 1;

output = zeros(fn_len, max_chan);

for chan = 1 : max_chan
  for i = 1 : fn_len
    idxStart = fn_idx(i);
    idxEnd = idxStart + fn_idx_gap;
    output(i, chan) = mean(input(idxStart : idxEnd, chan));
  end
end

end
